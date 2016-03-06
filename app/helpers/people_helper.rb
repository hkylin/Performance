module PeopleHelper
def draw_tree(person)
  #定义一个hash，用来存储每一个person的数据
  generation_hash ||= {}
  #定义一个hash，用来记录某个person的下一代的<ul></ul>是否已经添加
  h ||= {}

  #每一个person对应的数据为一个数组，用数组是因为要让下一代的数据插入到该person的<li></li>中
  generation_hash[person.id] = ["<li><a href=\"\#\">#{person.name}</a>","</li>"]

  #如果person有下一代，那么则进行以下操作
  unless person.sons.empty?
    #判断该person的下一代<ul></ul>是否已经添加，如果已添加，则不再添加了
    if h[person.id].nil?
      #将下一代对应的<ul>添加到person的</a>标签后
      generation_hash[person.id].first << "<ul>"
      #将下一代对应的</ul>添加到person的</li>前
      generation_hash[person.id].last.insert 0,"</ul>"
      #标记已经添加下一代的<ul></ul>
      h[person.id] = 1
    end

    person.sons.each do |son|
      #将下一代的数据插入到这一代数组的倒数第二个位置上
      #同时用到了递归，进行深度遍历
      generation_hash[person.id].insert(-2, draw_tree(son))
      #这样就形成了类似以下的格式
      #<li>
      #    <a href=\"\#\">#{person.name}</a>
      #    <ul>
      #        <li>
      #            <a href=\"\#\">#{son.name}</a>
      #        </li>
      #    </ul>
      #</li>
    end
  end
  #最后将generation_hash的values（一个嵌套的数组）进行flatten，然后再join成一个字符串返回
  generation_hash.values.flatten.join("")
end
end
