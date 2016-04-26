real oldclock = 0;
func real tic()
{
    real newclock = clock();
    real deltat = newclock - oldclock;
    oldclock = newclock;
    return deltat;
}
