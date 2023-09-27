local _g={}
local function Read(p,o)
  p=(o and io.popen or io.open)(p)
  if p then
    o=p:read("a")
    p:close()
    return o
  end
end
local function Try(a,b,c)
  if a then
    return b(a)
   else
    return c and c()
  end
end

_g.s='gh api%s -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" /repos/sgcell/via/actions/runs%s'
Try(Read(_g.s:format("","?per_page=99&status=completed"),true),function(f,x,y)
  x,y={i=0},_g.s:format(" --method DELETE","/")
  for a in f:sub(2,-2):gmatch("%b{}") do
    x.i=x.i+1
    if a:match('"event":"dynamic"') or a:match(',"name":"Test",') or a:match(',"name":"Reset",') or x.i>(#x+24) then
      a=a:match('{"id":(%d+),"name":')
      if a then
        table.insert(x,y..a)
      end
    end
  end
  print(("Dels: %s/%s"):format(#x,x.i),#x>0 and os.execute(table.concat(x,"\n")))
end)

Try(Read("README.md"),function(f,x)
  f={f:match("(%d%d%d%d)%-(%d%d)%-(%d%d) (%d%d):(%d%d)")}
  if f[1] then
    x=os.time{year=tonumber(f[1]),month=tonumber(f[2]),day=tonumber(f[3]),hour=tonumber(f[4]),min=tonumber(f[5])}-os.time()
    if x>0 then
      print("Updated:",os.date("!%H:%M",x))
      os.exit(true,true)
    end
   else
    print("Err: No time")
  end
end)

_g.s=Try(Read("curl -f --retry 1 https://lingeringsound.github.io/adblock_auto/Rules/adblock_auto_lite.txt",true),function(f,x)
  x=f:sub(1,99)
  if not x:find("[Adblock Plus",1,true) then
    print("adblock:",x)
    os.exit(true,true)
  end
  return f
  end,function()
  print("link adblock")
  os.exit(true,true)
end)

local function add(a,o)
  if not _g[a] then
    _g[a]=1
    a=a:match("^%s*(.-)%s*$")
    if #a>4 then
      _g[a]=1
      return o or table.insert(_g,a)
    end
  end
end

Try(Read("rules/dis.txt"),function(f)
  for a in f:gmatch("\n([^!][^\n]+)") do
    add(a,true)
  end
  end,function()
  print("Err: dis.txt")
end)

for a in _g.s:sub((_g.s:find("\n[^!]",9))):gmatch("[^\n]+") do
  add(a)
end

Try(Read("curl -f --retry 1 https://gp.adrules.top/adblock_lite.txt",true),function(f,x)
  x=f:sub(1,99)
  if x:find("[Adblock Plus",1,true) then
    table.insert(_g,"\n! →→→→ Cats-Team/AdRules ←←←← !")
    for a in f:sub((f:find("\n[^!]",9))):gmatch("[^\r\n]+") do
      add(a)
    end
    table.insert(_g,"! →→→→ Cats-Team/AdRules ←←←← !")
   else
    print("Err: AdRules",x)
  end
  end,function()
  print("Err: link AdRules")
end)

Try(Read("rules/add.txt"),function(f)
  for a in f:gmatch("\n([^!][^\n]+)") do
    add(a)
  end
  end,function()
  print("Err: add.txt")
end)

_g.c,_g.t=tostring(#_g-12),os.time()+os.time{year=1970,month=1,day=1,hour=8}
table.insert(_g,1,string.format([[[Adblock Plus 2.0]
! Title: 混合规则（轻量版）
! Total Count: %s
! Version: %s
! Homepage: https://sgcell.github.io/via/
]],_g.c,os.date("%y%m%d_%H%M",_g.t)))

io.open("adblock_lite.txt","w"):write(table.concat(_g,"\n")):close()

_g.s=Read("coolurl.user.js")
_g.s=[[脚本&拦截规则（轻量浏览器）

欢迎提交反馈 [【赞助】](http://top-tech.cc/pay)

# 脚本

- [【 链接重定向 ]]..(_g.s and _g.s:match("//%s*@version%s+(%S+)") or "")..[[ 】](https://sgcell.github.io/via/coolurl.user.js)  
  自动跳过中转页面  
  支持：酷安、知乎、简书、CSDN  

# 拦截规则

- [【 混合规则（轻量版） 】](https://sgcell.github.io/via/adblock_lite.txt)  
]]..os.date("  更新： %Y-%m-%d %H:%M  （",_g.t)..(_g.c)..[[）  
  适用于轻量浏览器

## 上游规则
<details>
<ul>
<br /><li><a href="https://github.com/lingeringsound/adblock_auto" target="_blank"> 混合规则精简版 </a></li>
<br /><li><a href="https://github.com/Cats-Team/AdRules" target="_blank"> AdRules AdBlock List Lite </a></li>
</ul>
</details>]]
io.open("README.md","w"):write(_g.s):close()

os.execute([[
git config --local user.email "sgcell@github.com"
git config --local user.name "SgCell"
git commit -am "Update"
git push origin]])
