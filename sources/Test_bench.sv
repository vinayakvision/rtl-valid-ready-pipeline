`timescale 1ns/1ps

module tb_pipeline_stage;

    parameter WIDTH = 32;

    logic clk;
    logic rst_n;

    // Input interface
    logic              in_valid;
    logic              in_ready;
    logic [WIDTH-1:0]  in_data;

    // Output interface
    logic              out_valid;
    logic              out_ready;
    logic [WIDTH-1:0]  out_data;

    // DUT instance
    pipeline_stage #(.WIDTH(WIDTH)) dut (
        .clk(clk),
        .rst_n(rst_n),

        .in_valid(in_valid),
        .in_ready(in_ready),
        .in_data(in_data),

        .out_valid(out_valid),
        .out_ready(out_ready),
        .out_data(out_data)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;   // 100 MHz clock

    //------------------------------------------
    // Test sequence
    //------------------------------------------
    initial begin
        // Initialize
        rst_n = 0;
        in_valid = 0;
        in_data  = 0;
        out_ready = 0;

        // Reset phase
        repeat(5) @(posedge clk);
        rst_n = 1;

        //----------------------------------
        // Test 1: Normal transfer
        //----------------------------------
        @(posedge clk);
        in_valid = 1;
        in_data  = 32'hA1;

        @(posedge clk);
        out_ready = 1;   // allow transfer

        @(posedge clk);
        in_valid = 0;

        //----------------------------------
        // Test 2: Backpressure
        //----------------------------------
        @(posedge clk);
        in_valid = 1;
        in_data  = 32'hB2;
        out_ready = 0;   // stall output

        repeat(3) @(posedge clk);  // hold data

        out_ready = 1;  // release stall

        @(posedge clk);
        in_valid = 0;

        //----------------------------------
        // Test 3: Continuous traffic
        //----------------------------------
        repeat(5) begin
            @(posedge clk);
            in_valid = 1;
            in_data  = $random;
        end

        @(posedge clk);
        in_valid = 0;

        //----------------------------------
        // Finish
        //----------------------------------
        repeat(5) @(posedge clk);
        $finish;
    end

    //------------------------------------------
    // Monitor transfers
    //------------------------------------------
    always @(posedge clk) begin
        if (in_valid && in_ready)
            $display("[%0t] INPUT  accepted: %h",
                      $time, in_data);

        if (out_valid && out_ready)
            $display("[%0t] OUTPUT sent:    %h",
                      $time, out_data);
    end

initial begin
$shm_open("wave.shm");
$shm_probe("ACTMF");
end

endmodule
