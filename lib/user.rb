guosong =User.create(username: :郭松 ,email: 'guosong@msjyamc.com.cn', password: '12345678',usertype: 'staff')
DepartmentUser.create(department: jh2, user: guosong, role: 'staff')


liyihe =User.create(username: :李奕赫 ,email: 'liyihe@msjyamc.com.cn', password: '12345678',usertype: 'staff')
DepartmentUser.create(department: jh2, user: liyihe, role: 'staff')


pangzheng =User.create(username: :庞正 ,email: 'pangzheng@msjyamc.com.cn', password: '12345678',usertype: 'staff')
DepartmentUser.create(department: jh2, user: pangzheng, role: 'staff')