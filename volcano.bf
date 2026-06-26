' Volcano, using external image file in basicFusion    K Moerman 2026
option explicit

' path to image file
const IMGPATH$="https://raw.githubusercontent.com/oonap0oo/basicFusion/refs/heads/main/volcano.png"
' can also be local path:
'const IMGPATH$="C:\...\volcano.png"
const NPARTICLES=40' number of lava particels in image
const NCLOUDS=3' number of cloud elllipses
const W=640'' image dimensions
const H=480
const W2=W/2
const H2=H/2
const VXMAX=10' velocity limits of lava particles
const VYMAX=25
const VYMIN=10
const VYRANGE=VYMAX-VYMIN
const X0=0' x coord. of origin of lava particles
const DT=1/10' a pseudo time step used to calc effect of gravity on v and effect of v on x,y
const GRAVITY=9.8*DT^2' effect of gravity
const VXCLOUDRANGE=2' limits of cloud velocity
const VYCLOUDMIN=.5
const VYCLOUDMAX=1
const ALPHACLOUDMIN=0.05' limits of starting transparency of clouds
const ALPHACLOUDRANGE=0.15
const RCLOUDMIN=1' limits of starting radius of clouds
const RCLOUDRANGE=5
const NLIGHTNING=6' number of points in 1 lighting
const PLIGHTNING=.04' probability for lighting at each overlay draw
const DRCLOUD=0.8' increase in cloud radius each redraw
const DALPHACLOUD=0.0015' reduction of aplha each redraw, when 0 cloud is re-init

type particle  'type to contain data of 1 lava particle
x as number' current position
y as number
vx as number' current velocity
vy as number
colr as number' red and green component of current color
colg as number
yterm as number' y value to stop updating and re-init (falls on the ground)
end type

type cloud 'type to contain data of 1 cloud ellipse
x as number' current position
y as number
r as number' longest radius of ellipse
vx as number' velocity of cloud ellipse
vx as number
alpha as number' start transparency of cloud ellipse
end type 

' arrays for lava particles and cloud ellipses
dim particles(NPARTICLES) as particle,clouds(NCLOUDS) as cloud
dim overlay' counter to draw overlay in intervals
' vars to do with external volcano image
dim shared volcano,xvolcano,yvolcano,wvolcano,hvolcano

randomize timer

call LoadVolcano' load external image, handle is volcano
call InitParticles' fill array with particle data
call InitClouds' fill array with cloud data

screen 12
overlay=1
do' main animation loop
    call DrawParticles' draw all lava partocles at their current x,y
    call AdvanceParticles' calculate new x,y,color for lava particles
    if overlay=0 THEN 
        call DrawOverlay' fill display with high transparency black to fade existing content 
        call DrawVolcano' (re)draw volcano image
        call DrawClouds' draw clouds at their current x,y,size and transparency
        call AdvanceClouds' calculate new x,y,alpha for clouds
        if rnd()<PLIGHTNING then call DrawLightning' maybe draw a lighting bolt
    end if
    overlay=(overlay+1) mod 4' overlay ramps from 0 to 3 and back to 0
sync(60)' wait for next display rendering with fps limit
loop

sub InitParticles' called once at start program, init all lava particles
local n
for n=0 to NPARTICLES
    CALL InitParticle(n)
next
end sub 

sub InitParticle(n)' (re)init 1 lava particle, all parameters get new start values
particles(n).vx=VXMAX*(rnd()-.5)*2
particles(n).vy=-VYMIN-VYRANGE*rnd()
particles(n).x=X0+particles(n).vx
particles(n).y=H2-hvolcano+20
particles(n).yterm=H2*0.6+H2*0.3*rnd())
particles(n).colr=255
particles(n).colg=215
end sub

sub AdvanceParticles' opdate all the lava particles
local n
for n=0 to NPARTICLES
    particles(n).vy=particles(n).vy+GRAVITY' vertical velocity updated, gravity pulling lava part. down
    particles(n).x=particles(n).x+particles(n).vx*DT' x,y position updated using velocity values
    particles(n).y=particles(n).y+particles(n).vy*DT
    if particles(n).y>particles(n).yterm then InitParticle(n)' lava part. has fallen on the ground: re-init
    if particles(n).x>W2 or particles(n).x<-W2 then InitParticle(n)' lava part. has left shor. edges creen : re-init
    if particles(n).colg>0 then' reduce green comp. until zero, goes from yellow to red 
        particles(n).colg=particles(n).colg-1
    else' the green comp. of lava part. is already zero     
        if particles(n).colr>0 then' reduce red comp. until zero goed from red to black
            particles(n).colr=particles(n).colr-1
         else 
            InitParticle(n)' color of lava particle reached black: re-init
         end if 
     end if 
next
end sub

sub DrawParticles' draw all lava particles with their color
local n,colstr,rstr,gstr
for n=0 to NPARTICLES
    rstr=str$(particles(n).colr)
    gstr=str$(particles(n).colg)
    colstr="rgb("+rstr+","+gstr+",0)"
    ellipse (W2+particles(n).x,H2+particles(n).y),2,2,colstr,1
next
end sub

sub DrawOverlay' fill image with nearly transparent black to fade existing content
paint "rgba(0,0,0,0.05)"
end sub

sub LoadVolcano' called once at start, load external image and determine parameters
volcano=loadimage(IMGPATH$)
wvolcano=imagewidth(volcano)
hvolcano=imageheight(volcano)
xvolcano=W2-wvolcano/2
yvolcano=H-hvolcano
end sub

sub DrawVolcano' (re)draw the volcano loaded from extrernal image
putimagestretched  (xvolcano,yvolcano),wvolcano,hvolcano,volcano
end sub

sub InitClouds' init all clouds filling array
local n
for n=0 to NCLOUDS
    InitCloud(n)
next 
end sub

sub InitCloud(n)' (re)init 1 cloud
clouds(n).x=X0' start position
clouds(n).y=H2-hvolcano+10
clouds(n).r=RCLOUDMIN+RCLOUDRANGE*rnd()' start radius
clouds(n).vx=(.5-rnd())*VXCLOUDRANGE' velocity, remains unchanged
clouds(n).vy=-VYCLOUDMIN-VYCLOUDMAX*rnd()
clouds(n).alpha=ALPHACLOUDMIN+ALPHACLOUDRANGE*rnd()' start alpha value for transparency
end sub

sub AdvanceClouds' update all parameters of clouds
local n
for n=0 to NCLOUDS
    clouds(n).y=clouds(n).y+clouds(n).vy' vertical position update using vy
    IF clouds(n).y<-H2 then InitCloud(n)' if cloud has reached upper edge, (re)init
    clouds(n).x=clouds(n).x+clouds(n).vx' horizontal position update using vy
    clouds(n).r=clouds(n).r+DRCLOUD' increase radius
    clouds(n).alpha=clouds(n).alpha-DALPHACLOUD' reduce alpha, cloud becomes more transparent
    if clouds(n).alpha<0 then InitCloud(n)' if cloud becomes invisible: re-init
next
end sub 

sub DrawClouds' (re)draw all clouds
local n,alpha$
for n=0 to NCLOUDS
    alpha$=str$(clouds(n).alpha)
    ellipse (W2+clouds(n).x,H2+clouds(n).y),clouds(n).r,0.2*clouds(n).r,"rgba(120,120,120,"+alpha$+")",1
next
end sub 

sub DrawLightning' draw a lightning bolt
local x,y,x2,y2,n,sign
x=(.5-rnd())*W2*.5' start position for bolt
y=0.2*H2+0.5*rnd()*H2
sign=sgn(x)' sign of x -1 or +1
x=x+W2
for n=1 to NLIGHTNING' add waypoints and draw lines
    x2=x:y2=y
    x=x+sign*4+sign*rnd()*25
    y=y+(.7-rnd())*50
    line (x,y)-(x2,y2),"yellow")
next
end sub
