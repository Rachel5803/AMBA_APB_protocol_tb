module clock_and_reset (
    output logic clock=0,
    output logic reset=0
    );

    // initial begin
    //     clock = 1'b0;
    //     reset = 1'b0;
    //     #10;
    //     reset = 1'b1;
    // end

    // always begin
    //     clock = ~clock;
    //     #10;
    // end
    initial begin
        clock<=0;
        forever begin
            #10 clock= ~clock;
        end
       
    end
    
    initial begin
        reset<=0;
        #10 reset= 'b1;
    end
    

endmodule : clock_and_reset

