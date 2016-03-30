module BT

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

  #判断是否包含前收费的日期
  def is_pre?(between_date)
    startd=between_date[0]
    endd=between_date[1]
    if((startd <= start_date)  && (start_date<=endd))
      return true
    else
      return false
    end
  end

  #判断是否包含后收费的日期
  def is_back?(between_date)
    startd=between_date[0]
    endd=between_date[1]
    if((startd <= end_date ) && (end_date<=endd))
      return true
    else
      return false
    end
  end

  def count_manage_fee(between_date)
    startd=between_date[0]
    endd=between_date[1]
    if(charge_type == Plan::CHARGE_TYPE[0])
      return count_rate_manage_fee(between_date)
    elsif (charge_type == Plan::CHARGE_TYPE[1])
      return count_pre_manage_fee(between_date)
    elsif (charge_type == Plan::CHARGE_TYPE[2])
      return count_back_manage_fee(between_date)
    else
      0.0
    end
  end

  #计算费率型管理费
  def count_rate_manage_fee(between_date)
    bt = bt_start_end(between_date)
    fee = (bt[1]-bt[0])*scale*rate/annual   #计算管理费
    return fee
  end

  #计算前收费
  def count_pre_manage_fee(between_date)
    fee = count_rate_manage_fee(between_date)
    if (is_pre?(between_date))
      fee += charge_amount
    end
    return fee
  end

  def count_back_manage_fee(between_date)
    fee = count_rate_manage_fee(between_date)
    if (is_back?(between_date))
      fee += charge_amount
    end
    return fee
  end

  def getCoRatio(userr)
    cooperations.each do |co|
      if(co.user == userr)
        return co.ratio
      end 
    end
  end

end