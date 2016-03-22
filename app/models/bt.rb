module BT
  def bt_start_end(startd,endd)
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
end