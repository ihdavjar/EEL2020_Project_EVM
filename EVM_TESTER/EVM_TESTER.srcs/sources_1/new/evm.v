`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.04.2023 16:11:25
// Design Name: 
// Module Name: evm
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module div_clk(clk,out);
    input clk;
    output out;
    reg [26:0] count;
    always @(posedge clk)
    begin
        count=count+1;
    end
    assign out = count[26];
endmodule

module BCD_to_Seven_Segment(A,B,C,D,a,b,c,d,e,f,g);
    input A,B,C,D;
    output a,b,c,d,e,f,g;
    assign a=~(A|C|(B&D)|((~B)&(~D)));
    assign b=~((~B)|A|((~C)&(~D))|(C&D));
    assign c=~(A|B|(~C)|D);
    assign d=~(A|((~B)&C)|((~B)&(~D))|(C&(~D))|(B&(~C)&D));
    assign e=~((C&(~D))|((~B)&(~D)));
    assign f=~(A|((~C)&(~D))|(B&(~C))|(B&(~D)));
    assign g=~(A|((~B)&C)|(B&(~C))|(C&(~D)));
endmodule

module display_votes(display_toggle,votes_a,votes_b,votes_c,ss,bin_votes);
    input [2:0]display_toggle;
    input [3:0]votes_a,votes_b,votes_c;
    output [6:0]ss;
    output reg [3:0]bin_votes;
    reg [3:0]temp;
    always @(display_toggle)
    begin
        if (display_toggle==1)
        begin
            temp=votes_a;
            bin_votes=votes_a;
        end
        else if (display_toggle==2)
        begin
            temp=votes_b;
            bin_votes=votes_b;
        end
        else if (display_toggle==4)
        begin
            temp=votes_c;
            bin_votes=votes_c;
        end
        
        else
        begin
            temp=4'b0000;
            bin_votes=4'b0000;
        end
    end
    BCD_to_Seven_Segment BCD1(temp[3],temp[2],temp[1],temp[0],ss[0],ss[1],ss[2],ss[3],ss[4],ss[5],ss[6]);
endmodule

module evm(reset_votes,test,enable_input,enable_t,vote_t,vote_in,display,final_votes,clk,new_clk,BCD_L,bin_out);
    //INPUTS:-
    //vote_in=> for input votes
    //votes_t=> Votes from the Tester
    //Enable_input=> Enable from the user
    //Enable_t=> Enable from the tester
    //reset_votes=> Reset votes on tester
    //clk=> input clock
    //display=> votes to be shown
    //test=> turns on the tester circuit
    
    //OUTPUTS:-
    //new_clk=> Divided clock
    //final_Votes=> BCD Output of the EVM
    //BCD_L=> Bits for selecting the single BCD panel
    //bin_out=> This will give the binary output of current number
    
    input reset_votes,enable_input,clk,enable_t,test;
    input [2:0]vote_in,display,vote_t;
    
    output [6:0]final_votes; //BCD Output of the EVM
    output new_clk;
    output [3:0]bin_out;
    output reg [3:0]BCD_L;
    
    reg temp_enable;// For Enable toggle internal register 
    reg [3:0]current_votes_a,current_votes_b,current_votes_c; //For storing current votes
    
    parameter a=3'b001,b=3'b01x,c=3'b1xx;
    wire enable;
    wire [2:0]vote;
    wire enabled;
    
    div_clk D1(clk,new_clk); //dividing the clock
    display_votes D2(display,current_votes_a,current_votes_b,current_votes_c,final_votes,bin_out);
    
    assign enable=test?enable_t:enable_input;
    
    assign vote[0]=test?vote_t[0]:vote_in[0];
    assign vote[1]=test?vote_t[1]:vote_in[1];
    assign vote[2]=test?vote_t[2]:vote_in[2];
    
    always @(posedge new_clk)
    begin
        BCD_L=4'b0111;
        if (reset_votes==1)
            begin
            current_votes_a=4'b0000;
            current_votes_b=4'b0000;
            current_votes_c=4'b0000;
            temp_enable=1'b1;
            end
     
        if (enabled==1)
        begin
            if (vote==a)
            begin
                current_votes_a<=current_votes_a+1;
                temp_enable<=~temp_enable;
            end
            else if (vote==b)
            begin
                current_votes_b<=current_votes_b+1;
                temp_enable<=~temp_enable;
            end
            else if (vote==c)
            begin
                current_votes_c<=current_votes_c+1;
                temp_enable<=~temp_enable;
            end
        end
    end
assign enabled=~(temp_enable^enable);
endmodule