`timescale 1ns/1ps

module pipeline_stage #(
    parameter WIDTH = 32
)(
    input  logic              clk,
    input  logic              rst_n,

    // Input interface
    input  logic              in_valid,
    output logic              in_ready,
    input  logic [WIDTH-1:0]  in_data,

    // Output interface
    output logic              out_valid,
    input  logic              out_ready,
    output logic [WIDTH-1:0]  out_data
);

    // Pipeline storage
    logic [WIDTH-1:0] data_reg;
    logic             valid_reg;

    // Ready when stage empty OR output consumes data
    assign in_ready  = !valid_reg || out_ready;

    assign out_valid = valid_reg;
    assign out_data  = data_reg;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid_reg <= 1'b0;
            data_reg  <= '0;
        end
        else begin
            // Accept new data
            if (in_valid && in_ready) begin
                data_reg  <= in_data;
                valid_reg <= 1'b1;
            end
            // Data consumed without replacement
            else if (out_ready) begin
                valid_reg <= 1'b0;
            end
        end
    end

endmodule
