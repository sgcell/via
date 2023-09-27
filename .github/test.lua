local function printf(t,...)
  if type(t)=="table" then
    local s={"{\n"}
    for k,v in pairs(t) do
      table.insert(s,("  %s=%s,\n"):format(k,v))
    end
    t=table.concat(s).."}"
  end
  print(t,...)
end
local g=setmetatable({},{__call=function(self,n)
    table.insert(self,[[
git config --local user.email "sgcell@github.com"
git config --local user.name "SgCell"
git commit -am "]]..(n or "Update")..[["
git push -f origin main]])
    os.execute(table.concat(self,"\n"))
    for k in pairs(self) do
      rawset(self,k,nil)
    end
      end,__index={del=function(self,t)
      for _,p in ipairs(t) do
        table.insert(self,"git rm -f "..p)
      end
      return self
      end,reset=function(self,n)
      table.insert(self,[[git init
git checkout --orphan latest_branch
git branch -D main
git branch -m main]])
      return self(n)
      end,add=function(self,s)
      table.insert(self,s)
      return self
end}})
if type(arg)=="table" then
  if arg[1] and arg[1]:find("^Reset ") then
    g:del{}:reset("Reset")
  end
end
--g:del{".github/workflows/Test.yml"}("Delete")
printf(arg)

print(arg[1])
