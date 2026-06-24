OPTION EXPLICIT
' Trying out basicFusion including sprite and font editor  K Moerman 2026
FASTGRAPHICS
CONST RAD2DEG=180/PI 
CONST W=640' width and height of image
CONST H=480
const R=280 ' radius of circles used for rotating background
CONST ANGLESTEP=2*PI/60 ' determines number of circles for background
CONST ANISTEP=2*PI/700' determines number of frames to rotate corcle background 360 deg
CONST W2=W/2
CONST H2=H/2

DIM SHARED ani, rsprite,anglesprite,xtext,txt$,framesprite,angle

GRAPHICS W,H ' custom image size
CALL DefineSpriteFont
ani=0
rsprite=0: anglesprite=0
xtext=0: txt$="BASIC"
framesprite=0
DO
    CLS
    CALL DrawCircles ' r-draw rotated background
    CALL PlaceText' draw text in updated position
    CALL PlaceSprite' place sprite in updated position       
    ani=ani+ANISTEP: IF ani>2*PI THEN ani=0' ramp ani from 0 to 2*PI
    xtext=xtext+1: IF xtext>W THEN xtext=0' ramp xtext from 0 to W
    IF xtext MOD 20=0 THEN framesprite=1-framesprite' now and then toggle sprite frame 
    SLEEP 10
    SYNC
LOOP

SUB DrawCircles' draw background of circles rotating in time
    LOCAL angle,x,y
    FOR angle=0 TO 2*PI-ANGLESTEP STEP ANGLESTEP
        x=H2*COS(angle+ani)
        y=H2*SIN(angle+ani)
        CIRCLE (x+W2,y+H2),R,"lime"
    NEXT
END SUB

SUB PlaceSprite' sprite spirals outwards
    LOCAL rotsprite,x,y,scalesprite
    rsprite=rsprite+0.5
    anglesprite=anglesprite-0.03
    x=rsprite*COS(anglesprite)
    y=rsprite*SIN(anglesprite)
    IF x>W2 OR y>H2 THEN rsprite=0' if sprite leaves screen restrart at center
    scalesprite=0.01*rsprite
    rotsprite=RAD2DEG*anglesprite-90  
    ' DRAWSPRITE id, x, y [, frame [, scale [, angle_deg]]]
    drawsprite 2,x+W2,y+H2,framesprite,scalesprite,rotsprite
END SUB

SUB PlaceText' each character of text 
    LOCAL x,dx,dy,ch,scale    
    FOR ch=0 TO LEN(txt$)
    angle=ch*0.6+ani*3
    dy=40*SIN(angle)
    dx=60*COS(angle)
    x=(xtext+ch*60+dx) MOD W
    scale=8-dy*0.1
    FONTCOLOR "hsl(" + STR$(ani*RAD2DEG+ch*45) + ",100%,60%)"
    PRINTFONT 0, x, 100+dy, MID$(txt$,ch,1), scale
    NEXT
END SUB 

' sprite and font data generated using the Spriteshop and Fonteditor 
SUB DefineSpriteFont
' --- DEFINED SPRITE ID: 2 (32x32) ---
DEFSPRITE 2, 32, 32
SPRITEDATA 2, 0, 1, ",,,,,,,,,,,,,,#ffff55,#ffff55,#ffff55,#ffff55,,,,,,,,,,,,,,"
SPRITEDATA 2, 0, 2, ",,,,,,,,,,,,,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,,,,,,,,,,,,,"
SPRITEDATA 2, 0, 3, ",,,,,,,,,,,,,,#ffff55,#ffff55,#ffff55,#ffff55,,,,,,,,,,,,,,"
SPRITEDATA 2, 0, 4, ",,,,,,,,,,,,,,,#5555ff,#5555ff,,,,,,,,,,,,,,,"
SPRITEDATA 2, 0, 5, ",,,,,,,,,,,,,,,#5555ff,#5555ff,,,,,,,,,,,,,,,"
SPRITEDATA 2, 0, 6, ",,,,,,,,,,,,,,,#5555ff,#5555ff,,,,,,,,,,,,,,,"
SPRITEDATA 2, 0, 7, ",,,,,,,,,,,,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,,,,,,,,,,,,"
SPRITEDATA 2, 0, 8, ",,,,,,,,,,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,,,,,,,,,,"
SPRITEDATA 2, 0, 9, ",,,,,,,,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,,,,,,,,"
SPRITEDATA 2, 0, 10, ",,,,,,,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#aa5500,#ffff55,#ffff55,#aa5500,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,,,,,,,"
SPRITEDATA 2, 0, 11, ",,,,#0000aa,#0000aa,#0000aa,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#aa5500,#aa5500,#aa5500,#aa5500,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#5555ff,#5555ff,#5555ff,,,,"
SPRITEDATA 2, 0, 12, ",#0000aa,#0000aa,#0000aa,#0000aa,#0000aa,#0000aa,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#aa5500,#aa5500,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,"
SPRITEDATA 2, 0, 13, "#0000aa,#0000aa,#0000aa,#0000aa,#0000aa,#0000aa,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#aa5500,#aa5500,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff"
SPRITEDATA 2, 0, 14, "#0000aa,#0000aa,#0000aa,#0000aa,#0000aa,#0000aa,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#aa5500,#aa5500,#aa5500,#aa5500,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff"
SPRITEDATA 2, 0, 15, "#0000aa,#0000aa,#0000aa,#0000aa,#0000aa,#0000aa,#0000aa,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#aa5500,#aa5500,#aa5500,#aa5500,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff"
SPRITEDATA 2, 0, 16, "#0000aa,#0000aa,#0000aa,#0000aa,#0000aa,#0000aa,#0000aa,#0000aa,#0000aa,#5555ff,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#ffff55,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff"
SPRITEDATA 2, 0, 17, ",#0000aa,#0000aa,#0000aa,#0000aa,#0000aa,#0000aa,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,"
SPRITEDATA 2, 0, 18, ",,#0000aa,#0000aa,#0000aa,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,,"
SPRITEDATA 2, 0, 19, ",,,#0000aa,#5555ff,#5555ff,#5555ff,#5555ff,#ffff55,#ffff55,#ffff55,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#ffff55,#ffff55,#ffff55,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,,,"
SPRITEDATA 2, 0, 20, ",,,,#5555ff,#5555ff,#5555ff,#5555ff,#ffff55,#ffff55,#ffff55,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#ffff55,#ffff55,#ffff55,#5555ff,#5555ff,#5555ff,#5555ff,,,,"
SPRITEDATA 2, 0, 21, ",,,,,,,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,,,,,,,"
SPRITEDATA 2, 0, 22, ",,,,,,,,,,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,#5555ff,,,,,,,,,,"
SPRITEDATA 2, 1, 3, ",,,,,,,,,,,,,,,#5555FF,#5555FF,,,,,,,,,,,,,,,"
SPRITEDATA 2, 1, 4, ",,,,,,,,,,,,,,,#5555FF,#5555FF,,,,,,,,,,,,,,,"
SPRITEDATA 2, 1, 5, ",,,,,,,,,,,,,,,#5555FF,#5555FF,,,,,,,,,,,,,,,"
SPRITEDATA 2, 1, 6, ",,,,,,,,,,,,,,,#5555FF,#5555FF,,,,,,,,,,,,,,,"
SPRITEDATA 2, 1, 7, ",,,,,,,,,,,,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,,,,,,,,,,,,"
SPRITEDATA 2, 1, 8, ",,,,,,,,,,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,,,,,,,,,,"
SPRITEDATA 2, 1, 9, ",,,,,,,,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#ffffff,#ffffff,#aaaaaa,#aaaaaa,#aaaaaa,,,,,,,,"
SPRITEDATA 2, 1, 10, ",,,,,,,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#AA5500,#aaaaaa,#aaaaaa,#AA5500,#aaaaaa,#aaaaaa,#ffffff,#ffffff,#aaaaaa,#aaaaaa,#aaaaaa,,,,,,,"
SPRITEDATA 2, 1, 11, ",,,,#0000AA,#0000AA,#0000AA,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#AA5500,#AA5500,#AA5500,#AA5500,#aaaaaa,#aaaaaa,#aaaaaa,#ffffff,#aaaaaa,#aaaaaa,#aaaaaa,#5555FF,#5555FF,#5555FF,,,,"
SPRITEDATA 2, 1, 12, ",#0000AA,#0000AA,#0000AA,#0000AA,#0000AA,#0000AA,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#AA5500,#AA5500,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#ffffff,#ffffff,#aaaaaa,#aaaaaa,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,"
SPRITEDATA 2, 1, 13, "#0000AA,#0000AA,#0000AA,#0000AA,#0000AA,#0000AA,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#AA5500,#AA5500,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#ffffff,#aaaaaa,#aaaaaa,#aaaaaa,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF"
SPRITEDATA 2, 1, 14, "#0000AA,#0000AA,#0000AA,#0000AA,#0000AA,#0000AA,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#AA5500,#AA5500,#AA5500,#AA5500,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF"
SPRITEDATA 2, 1, 15, "#0000AA,#0000AA,#0000AA,#0000AA,#0000AA,#0000AA,#0000AA,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#AA5500,#AA5500,#AA5500,#AA5500,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF"
SPRITEDATA 2, 1, 16, "#0000AA,#0000AA,#0000AA,#0000AA,#0000AA,#0000AA,#0000AA,#0000AA,#0000AA,#5555FF,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#aaaaaa,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF"
SPRITEDATA 2, 1, 17, ",#0000AA,#0000AA,#0000AA,#0000AA,#0000AA,#0000AA,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,"
SPRITEDATA 2, 1, 18, ",,#0000AA,#0000AA,#0000AA,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,,"
SPRITEDATA 2, 1, 19, ",,,#0000AA,#5555FF,#5555FF,#5555FF,#5555FF,#5555ff,#5555ff,#5555ff,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555ff,#5555ff,#5555ff,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,,,"
SPRITEDATA 2, 1, 20, ",,,,#5555FF,#5555FF,#5555FF,#5555FF,#5555ff,#5555ff,#5555ff,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555ff,#5555ff,#5555ff,#5555FF,#5555FF,#5555FF,#5555FF,,,,"
SPRITEDATA 2, 1, 21, ",,,,,,,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,,,,,,,"
SPRITEDATA 2, 1, 22, ",,,,,,,,,,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,#5555FF,,,,,,,,,,"

' --- FONT ID 0 (5x5) ---
DEFFONT 0, 5, 5
FONTDATA 0, 65, "01110", "11001", "11001", "11111", "11001"
FONTDATA 0, 66, "11110", "11001", "11110", "11001", "11110"
FONTDATA 0, 67, "01110", "11001", "11000", "11001", "01110"
FONTDATA 0, 73, "11110", "01100", "01100", "01100", "11111"
FONTDATA 0, 83, "11110", "11000", "11111", "00001", "11111"

END SUB