cd /d "C:\Users\jerom\Downloads\ServiQ"
echo Current directory:
cd
echo.
echo Git status:
git status
echo.
echo Adding files...
git add -A
echo.
echo Committing...
git commit -m "CRITICAL FIX: Restore glob pattern in app.js - Pages were not loading"
echo.
echo Pushing...
git push origin main
echo.
echo Done!
pause
