module BT
  #对于按年计提的计算，应该是按照年做区间，返回数组[[start,end,annual]] 调用bt_start_end的时候，做判断，调用这个还是正常的调用前面的那个
  def bt_start_ends(bt)
    rt=Array.new
    a=bt[0].year
    b=bt[1].year
    return rt << [bt[0],bt[1],year_annual(a)] if (a==b)
    while a < b do 
      if(a == bt[0].year) #循环中的第一年
        rt << [bt[0], Date.new(a,12,31), year_annual(a)]
      else
        rt << [Date.new(a-1,12,31), Date.new(a,12,31), year_annual(a)]
      end
      a+=1
    end
    rt << [Date.new(a-1,12,31),bt[1],year_annual(a)] if (a==b)
    return rt
  end

  def year_annual(year)
    (Date.new(year,12,31)-Date.new(year-1,12,31)).to_i
  end
  
  

  #时间区间取交集
  def bt_start_end(between_date)
    startd=between_date[0]
    endd=between_date[1]
    #组织参数
    if(startd>=end_date)  #项目不在范围内,项目在查找周期之前
      return 0
    end
    if(start_date >= endd)  #项目不在范围内,项目在查找周期之后
      return 0
    end
    if((start_date-startd).to_i >0 )
      startd=start_date
    end
    if((endd-end_date).to_i >0 )
      endd=end_date
    end 
    [startd,endd] 
  end

  def is_contain?(dated)
    if((start_date <= dated)  && (dated<=end_date))
      return true;
    else
      return false;
    end
  end

  #判断管理费分配日  是否在周期范围内
  def is_contain_charge_date?(between_date)
    startd=between_date[0]
    endd=between_date[1]
    if((startd <= charge_date)  && (charge_date<=endd))
      return true;
    else
      return false;
    end
  end

  def count_manage_fee(between_date)
    startd=between_date[0]
    endd=between_date[1]
    if(charge_type == Plan::CHARGE_TYPE[0])
      return count_rate_manage_fee(between_date)
    elsif (charge_type == Plan::CHARGE_TYPE[1])
      return count_fixed_manage_fee(between_date)
    elsif (charge_type == Plan::CHARGE_TYPE[2])
      return count_fixed_manage_fee(between_date)
    else
      0.0
    end
  end

  #计算费率型管理费
  def count_rate_manage_fee(between_date)
    if annual!=0
      bt = bt_start_end(between_date)
      fee = (bt[1]-bt[0])*scale*rate/annual   #计算管理费
      return fee
    else
      sum=0.0
      bts = bt_start_ends(between_date)
      bts.each do |x|
        sum+=(x[1]-x[0])*scale*rate/x[2]   #计算管理费
      end
      return sum
    end
  end

  #计算带有一次性提取的费用（前收费，后收费）  
  def count_fixed_manage_fee(between_date)
    fee = count_rate_manage_fee(between_date)
    if (is_contain_charge_date?(between_date))
      fee += charge_amount
    end
    return fee
  end

  def getCoRatio(userr)
    cooperations.each do |co|
      logger.info "#{co.user.name}-----#{co.ratio}"
      if(co.user == userr)
        logger.info "#{co.user.name}=======#{co.ratio}"
        return co.ratio
      end 
    end
    return 0.0
  end

end