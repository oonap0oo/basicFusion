' String art animation            K Moerman 2026

const W=640' size of image
const H=480
const W2=W/2: const H2=H/2
const RAD2DEG=180/PI
const Npoints=40' number of points on circle used
const SHIFT=0.4' displaces points on circle to shift center of figure
const ANGLESTEP=2*PI/(Npoints-1)

type pointtype' structure or USD for 1 point
x as number
y as number
end type

dim p1 as pointtype,p2 as pointtype' 2 variables of type pointtype

screen 12' 540x480
fastgraphics 

phase=.2
phase2=.1
do 
    cls
    for u=0 to Npoints-1' iterate through all points on circle
        angle1=CalcAngle(u,phase,phase2)
        p1=CalcCoord(angle1)
        for v=1 to u-1' iterate to points still to be drawn a line to
        if (u+2*v) mod 3=0 then' only draw some lines to add effect to figure 
            angle2=CalcAngle(v,phase,phase2)
            p2=CalcCoord(angle2)
            line(p1.x,p1.y)-(p2.x,p2.y),"lime"
        end if
        next
    next
    phase=phase+0.008: if phase>2*PI then phase=0
    phase2=phase2+0.003: if phase2>2*PI then phase2=0
    sync
loop

' calc angle point on circle from point number n and 2 parameters for animation
function CalcAngle(n,ph1,ph2)
local a
a=ANGLESTEP*n' point number to angle of point
a=a+SHIFT*sin(a+ph1+ph2)' displacing points on circle to shift center of figure
CalcAngle=a+ph1' also making complete drawing rotate
end function 

' calc x,y coord. for point on circle from angle
function CalcCoord(angle) as pointtype
local p as pointtype
p.x=W2+H2*cos(angle)
p.y=H2+H2*sin(angle)
CalcCoord=p
end function