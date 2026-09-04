@echo off
set msg=提交

if not "%1"=="" set msg=%1

git add .
git commit -m "%msg%"
git push
echo 推送完成！
pause