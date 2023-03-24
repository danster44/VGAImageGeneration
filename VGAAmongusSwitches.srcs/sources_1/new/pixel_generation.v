`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Daniel Ferreira
// 
// Create Date: 01/06/2023 04:04:07 PM
// Design Name: VGA Pixel Generation Circuit 
// Module Name: pixel_generation
// Project Name: VGAAmongus
// Target Devices: Basys3
// Tool Versions: 
// Description: Basic pixel generation circuit 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module pixel_generation(
    input [11:0] sw, 
    input video_on,
    input [9:0] x,
    input [9:0] y,
    output reg [11:0] rgb
    );
    
    // RGB Color Values
    parameter RED    = 12'h00F; //like the switches, but divide by 4 
    parameter GREEN  = 12'h0F0; //switch 2 high 
    parameter BLUE   = 12'hF00; //switch 3 high 
    parameter YELLOW = 12'h0FF; //switch 1,2 high, 3 low, you get the idea 
    parameter AQUA   = 12'hFF0;     
    parameter VIOLET = 12'hF0F;     
    parameter WHITE  = 12'hFFF;     
    parameter BLACK  = 12'h000;
    parameter GRAY   = 12'hAAA; //we only get gray when there's some of each color, lighter gray means lower letters, BCDEF etc.
    
    //Pixel Location Signals
    
    wire outline_on, amongus_on, glass_on,black_on, background_on;
    
    //All the pixel boundaries for the design, can be defined however you want 
    assign outline_on  = ((x >= 80)   && (x < 161)   &&  (y >= 360) && (y < 391) || (x >= 80)   && (x < 161)   &&  (y >= 150) && (y < 181) || (x >= 40)   && (x < 81)   &&  (y >= 180) && (y < 361) || (x >= 400)   && (x < 441)   &&  (y >= 420) && (y < 451) || (x >= 400)   && (x < 561)   &&  (y >= 450) && (y < 480) || (x >= 280)   && (x < 320)   &&  (y >= 420) && (y < 451) ||(x >= 200)   && (x < 241)   &&  (y >= 60) && (y < 91) || (x >= 480)   && (x < 521)   &&  (y >= 60) && (y < 91) || (x >= 520)   && (x < 561)   &&  (y >= 90) && (y < 121)|| (x >= 560)   && (x < 601)   &&  (y >= 150) && (y < 241) || (x >= 280)   && (x < 561)   &&  (y >= 120) && (y < 151) || (x >= 240)   && (x < 281)   &&  (y >= 150) && (y < 241) || (x >= 240)   && (x < 481)   &&  (y >= 30) && (y < 61) || (x >= 160)   && (x < 201)   &&  (y >= 90) && (y < 479)|| (x >= 520)   && (x < 561)   &&  (y >= 240) && (y < 479)|| (x >= 200)   && (x < 321)   &&  (y >= 450) && (y < 479)|| (x >= 280)   && (x < 441)   &&  (y >= 390) && (y < 421)|| (x >= 280)   && (x < 521)   &&  (y >= 240) && (y < 271));//|| (x >= 280)   && (x < 561)   &&  (y >= 120) && (y < 151)|| (x >= 400)   && (x < 520)   &&  (y >= 450) && (y < 480)|| (x >= 280)   && (x < 321)   &&  (y >= 420) && (y < 451)|| (x >= 400)   && (x < 441)   &&  (y >= 420) && (y < 451)|| (x >= 240)   && (x < 281)   &&  (y >= 150) && (y < 241)|| (x >= 560)   && (x < 601)   &&  (y >= 250) && (y < 241)|| (x >= 200)   && (x < 241)   &&  (y >= 60) && (y < 91)|| (x >= 40)   && (x < 81)   &&  (y >= 180) && (y < 301)|| (x >= 480)   && (x < 521)   &&  (y >= 60) && (y < 91)|| (x >= 520)   && (x < 561)   &&  (y >= 90) && (y < 121)|| (x >= 80)   && (x < 161)   &&  (y >= 360) && (y < 391));
    assign amongus_on = ((x >= 240)   && (x < 281)   &&  (y >= 120) && (y < 151) || (x >= 480)   && (x < 521)   &&  (y >= 90) && (y < 121) || (x >= 240)   && (x < 481)   &&  (y >= 60) && (y < 121) || (x >= 240)   && (x < 281)   &&  (y >= 240) && (y < 271) || (x >= 200)   && (x < 241)   &&  (y >= 90) && (y < 271) || (x >= 441)   && (x < 521)   &&  (y >= 390) && (y < 451) || (x >= 201)   && (x < 281)   &&  (y >= 390) && (y < 451) || (x >= 201)   && (x < 521)   &&  (y >= 270) && (y < 391) || (x >= 80)   && (x < 161)   &&  (y >= 180) && (y < 361));
    assign glass_on = ((x >= 280)   && (x < 561)   &&  (y >= 150) && (y < 241));
    assign background_on = ((x >= 40)   && (x < 81)   &&  (y >= 360) && (y < 391) || (x >= 40)   && (x < 81)   &&  (y >= 150) && (y < 181) || (x >= 160)   && (x < 201)   &&  (y >= 60) && (y < 91) || (x >= 600)   && (x < 640)   &&  (y >= 0) && (y < 480) || (x >= 560)   && (x < 640)   &&  (y >= 90) && (y < 151) || (x >= 520)   && (x < 640)   &&  (y >= 60) && (y < 91) || (x >= 480)   && (x < 640)   &&  (y >= 30) && (y < 61) || (x >= 560)   && (x < 640)   &&  (y >= 240) && (y < 480) || (x >= 320)   && (x < 401)   &&  (y >= 420) && (y < 480) || (x >= 440)   && (x < 521)   &&  (y >= 150) && (y < 181) || (x >= 0)   && (x < 640)   &&  (y >= 0) && (y < 31) || (x >= 0)   && (x < 241)   &&  (y >= 0) && (y < 61) || (x >= 0)   && (x < 41)   &&  (y >= 0) && (y < 480) || (x >= 0)   && (x < 160)   &&  (y >= 390) && (y < 480) || (x >= 0)   && (x < 160)   &&  (y >= 0) && (y < 151));
   
   
    //Simple stuff:
    //If video_on low, display black screen. else, once we hit our boundaries, fill it with a color
    always @*
        if(~video_on)
            rgb = BLACK;
        else
            if(background_on)
                rgb = WHITE;
            else if(amongus_on)
                rgb = sw [11:0];
            else if(glass_on)
                rgb = BLUE;
            else if(outline_on)
                rgb = 12'b0;
           
endmodule
