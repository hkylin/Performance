class Project < ActiveRecord::Base
  include BT

  belongs_to :user
  belongs_to :plan
  belongs_to :department
  has_many :modifications, as: :modificationable, :dependent => :destroy
  
  has_many :cooperations, as: :cooperationable, dependent: :destroy, inverse_of: :cooperationable
  accepts_nested_attributes_for :cooperations, reject_if: :all_blank, allow_destroy: true

  RISK_TYPE = %w(正常 风险)  
  validates_inclusion_of :risk, in: RISK_TYPE

  CHARGE_TYPE = %w(普通 前端收费 后端收费)  
  validates_inclusion_of :charge_type, in: CHARGE_TYPE  

  validates_presence_of :plan_id, :start_date, :end_date, :name, :rate   , :message => "不能为空" # 最少 2 
  validates_length_of :name, :minimum => 2 , :message => "名称最少4个字节", :allow_blank => true  
  # validates_numericality_of :scale, :greater_than_or_equal_to => 30000000 , :message => "最小规模3000万" 
  validates_numericality_of :scale
  validates_numericality_of :channel_cost, :greater_than_or_equal_to => 0.0 , :less_than_or_equal_to => 1.0 , :message => "请合理设置通道费用" 
  # validates_uniqueness_of :name , :on => :create,:message => "计划名称不唯一" 


  scope :cc, -> { where("channel_cost > 0 AND channel_cost <=1") }   
  
  def self.find_departments
    Department.all.collect { |department| [department.name, department.id] } 
  end

  def self.find_plans
    Plan.all.collect { |plan| [plan.name, plan.id] } 
  end   

  ###################项目管理费收入计算###########################
  def method_missing(method_name, *args, &block)
    logger.info "-------Project 调用 method_missing  = #{method_name}-------"
    sum=0.0
    modifications.each do |modify|
      logger.info "-----#{modify}-------"
      sum = sum + modify.send(method_name, *args, &block)
    end
    return sum
  end

  def count_income(userr,between_date)
    if modifications.size==0 
      ratio = getCoRatio(userr)*(1-channel_cost)
      if(annual!=0)
        bt = bt_start_end(between_date)
        return 0 if (bt==0)
        income =(bt[1]-bt[0])*scale*rate/annual   #计算管理费
        if (is_charge_computer?(between_date))
          income += charge_amount
        end
        return income * ratio   #计算管理费
      else
        sum=0.0
        bts = bt_start_ends(between_date)
        return 0 if (bts==0)
        bts.each do |x|
          sum+=(x[1]-x[0])*scale*rate/x[2]   #计算管理费
        end
        if (is_charge_computer?(between_date))
          sum += charge_amount
        end
        return sum * ratio
      end
    else
      return mo_count_income(userr,between_date)
    end
  end

  #规模收入计算
  def count_scale(userr,dated=Date.current)
    if modifications.size==0 
      if is_contain?(dated)
        ratio = getCoRatio(userr)*(1-channel_cost)
        logger.info "#{name}***规模：#{scale}     用户：#{userr.name}    比例：#{ratio}***"
        return scale*ratio   #计算管理费
      else
        return 0.0
      end
    else
      return mo_count_scale(userr,dated)
    end
  end

  def count_full_scale(dated=Date.current)
    if modifications.size==0 
      if is_contain?(dated)
        return scale   #计算管理费
      else
        return 0.0
      end
    else
      sum=0.0
      modifications.each do |mo|
        if mo.is_contain?(dated)
          sum += mo.scale
        end
      end
      return sum
    end
  end
  #年化的规模收入计算
  def count_annual_scale(userr,between_date=Date.one_year) #delme?
    if modifications.size==0 
      bt = bt_start_end(between_date)
      ratio = getCoRatio(userr)*(1-channel_cost)
      return scale*ratio*(bt[1]-bt[0])/Date.year_days   #计算管理费
    else
      return mo_count_annual_scale(userr,between_date)
    end
  end
  #项目使用外部计划通道，通道管理费收入计算
  def passageway_income(between_date)
    if modifications.size==0 
      if(annual!=0)
        bt = bt_start_end(between_date)
        return 0 if (bt==0)
        income = (bt[1]-bt[0])*scale*rate/annual   #计算管理费
        if (is_charge_computer?(between_date))
          income += charge_amount
        end
        return income * channel_cost
      else
        sum=0.0
        bts = bt_start_ends(between_date)
        return 0 if (bts==0)
        bts.each do |x|
          sum += (x[1]-x[0])*scale*rate/x[2]   #计算管理费
        end
        if (is_charge_computer?(between_date))
          sum += charge_amount
        end
        return sum * channel_cost
      end
    else
      return mo_passageway_income(between_date)
    end
  end
  #项目使用外部计划通道，通道规模收入计算
  def passageway_scale(dated)
    if modifications.size==0 
      if (is_contain?(dated))
        return scale*channel_cost   #计算管理费
      else
        return 0.0
      end
    else
      return mo_passageway_scale(dated)
    end
  end

  def passageway_annual_scale(between_date)#delme?
    if modifications.size==0 
      bt = bt_start_end(between_date)
      return scale*channel_cost*(bt[1]-bt[0])/Date.year_days   #计算管理费
    else
      return mo_passageway_annual_scale(between_date)
    end
  end

#REF http://michael-roshen.iteye.com/blog/1668296
#REF http://duyw.github.io/blog/2014/01/29/rails-dao-chu-csv/
  def self.to_csv(datas)
    # options = {}
    options = {
        # col_sep: ";",
        # row_sep: "\n",
        # encoding: 'ISO-8859-1'
        encoding: Encoding::UTF_8
        # encoding: 'UTF-8'
    }

    csv_res=CSV.generate(options) do |csvv|
      names=%w[项目编号 项目名称 资管计划 成立日期 到期日 规模 管理费率 收费模式 前后端收费金额 固定费用收取日期 部门 合作伙伴 备注 通道费率 年化 风险 协作者 比例 协作类型 规模计算 收入计算 通道费用 添加日期 更新日期]

      csvv << names
        datas.each do |p|
          p.cooperations.each do |co|
            csv=Array.new
            csv << p.id
            csv << p.name
            csv << p.plan.name
            csv << p.start_date
            csv << p.end_date
            csv << p.scale
            csv << p.rate
            csv << p.charge_type
            csv << p.charge_amount
            csv << p.charge_date
            csv << p.department.name
            csv << p.parter
            csv << p.notes
            csv << p.channel_cost
            csv << p.annual
            csv << p.risk
            csv << co.user.name
            csv << co.ratio
            csv << co.co_type
            csv << p.count_scale(co.user)
            csv << p.count_income(co.user, Date.since_this_year)
            csv << p.channel_cost
            csv << p.created_at
            csv << p.updated_at
            csvv << csv
          end
        # <td><%=f2 @project.count_scale current_user%></td>
        # <td><%=f2 @project.count_income current_user, Date.since_this_year%></td>
        # <td><%=f2 @project.channel_cost%></td>
      end
    end
    # csv_res.encode('WINDOWS-1252', :undef => :replace, :replace => '') del 

  end

  ##############################################################
  def self.csv_line(csvv,datas,current_user)
    datas.each do |p|
      p.cooperations.each do |co|
        if co.user.id == current_user.id
          csv=Array.new
          csv << p.id
          csv << p.name.force_encoding("UTF-8")
          csv << p.plan.name.force_encoding("UTF-8")
          csv << p.start_date
          csv << p.end_date
          csv << p.scale
          csv << p.rate
          csv << p.charge_type
          csv << p.charge_amount
          csv << p.charge_date
          csv << p.department.name.force_encoding("UTF-8")
          csv << p.parter
          csv << p.notes
          csv << p.channel_cost
          csv << p.annual
          csv << p.risk
          csv << co.user.name.force_encoding("UTF-8")
          csv << co.ratio
          csv << co.co_type
          csv << p.count_scale(co.user)
          csv << p.count_income(co.user, Date.since_this_year)
          csv << p.channel_cost
          csv << p.created_at
          csv << p.updated_at
          csvv << csv
        end
      end
    end
  end

  def self.my_to_csv(my_projects,have_me_projects,current_user)
    options = {
        # col_sep: ";",
        # row_sep: "\n",
        # encoding: 'ISO-8859-1'
        encoding: Encoding::UTF_8
    }

    csv_res=CSV.generate(options) do |csvv|
      names=%w[项目编号 项目名称 资管计划 成立日期 到期日 规模 管理费率 收费模式 前后端收费金额 固定费用收取日期 部门 合作伙伴 备注 通道费率 年化 风险 协作者 比例 协作类型 规模计算 收入计算 通道费用 添加日期 更新日期]
      csvv << names
      csv_line(csvv,my_projects,current_user)
      csv_line(csvv,have_me_projects,current_user)
      csvv
    end
  end




  #通过cooperation计算，只计算单一计划，集合类计划不计算
  def count_co_fee_between(between_date,userr) #delme?
    count_co_fee_self(between_date,userr)
  end

  def count_co_fee_self(between_date, userr )
    logger.info "=========------开始计算项目:  #{name}-----=========="
    if modifications.size == 0
      bt = bt_start_end(between_date)
      ratio = getCoRatio(userr)
      return (bt[1]-bt[0])*scale*rate*ratio/annual   #计算管理费
    else
      sum = 0.0
      modifications.each do |mo|
        fee=mo.count_co_fee_self(between_date,userr)
        sum += fee
        logger.info fee
      end   
      return sum   
    end
  end

  def count_fee_self(between_date)
    bt=bt_start_end(between_date)
    (bt[1]-bt[0])*scale*rate/365   #计算管理费
  end

# a = [1,2,3,4,5,6] ; b = a.each{|x|, sum += x};
  # TODO  
  def count_fee_modifys(between_date)
    sum=0.0
    modifications.each do |modify|
      sum = sum + modify.count_fee_between(between_date)
    end
    sum
  end

  def count_fee_between(between_date)
    if modifications.size > 0 
      count_fee_modifys(between_date)
    else
      count_fee_self(between_date)
    end
  end

  def count_scale_old(at_date) #计算单一计划管理费
    if modifications.size > 0
      count_scale_modifys at_date
    else
      count_scale_self at_date      
    end
  end

  def count_scale_self(at_date)
    if( start_date <= at_date && at_date < end_date )  #注意开始时间  结束时间边界值
      return scale
    else
      return 0
    end 
  end

  def count_scale_modifys(at_date)  #modify日期必须是连续的
    modifications.each do |modify|
      if( modify.start_date <= at_date && at_date < modify.end_date )  #注意开始时间  结束时间边界值
        return modify.scale
      end
    end
  end

  def count_fee
    (end_date-start_date)*scale*rate/365
  end

  def count_date
    end_date-start_date
  end

end