`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.06.2026 16:21:40
// Design Name: 
// Module Name: tb1
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

// ============================================================================
// BLOCK 1: MASTER DRIVER STIMULUS AGENT
// ============================================================================
module axicb_master_driver (
    input  wire        aclk,
    input  wire        aresetn,
    input  wire        srst,
    output logic       m_awvalid,
    input  wire        m_awready,
    output logic [7:0] m_awch,
    output logic       m_wvalid,
    input  wire        m_wready,
    output logic       m_wlast,
    output logic [7:0] m_wch,
    input  wire        m_bvalid,
    output logic       m_bready
);

    // Initialized to prevent X-propagation in Vivado
    initial begin
        m_awvalid = 0;
        m_awch    = 0;
        m_wvalid  = 0;
        m_wlast   = 0;
        m_wch     = 0;
        m_bready  = 0;
    end

    task automatic drive_write_burst(
        input bit [7:0] addr,
        input int       burst_len,
        input bit [3:0] master_id
    );
        begin
            $display("[TIME: %0t ns] [MASTER %0d] --> Initiating Write to Addr: 0x%h", $time, master_id, addr);
            
            // 1. Address Write Phase
            m_awvalid = 1;
            m_awch    = addr;
            @(posedge aclk);
            while (!m_awready) @(posedge aclk);
            m_awvalid = 0;
            $display("[TIME: %0t ns] [MASTER %0d]   STAGE OK: Address Accepted (AWREADY)", $time, master_id);

            // 2. Data Write Burst Phase
            for (int beat = 0; beat < burst_len; beat++) begin
                m_wvalid = 1;
                m_wch    = (master_id << 4) | beat;
                m_wlast  = (beat == burst_len - 1);
                @(posedge aclk);
                while (!m_wready) @(posedge aclk);
            end
            m_wvalid = 0;
            m_wlast  = 0;
            $display("[TIME: %0t ns] [MASTER %0d]   STAGE OK: Data Burst Sent (WREADY)", $time, master_id);

            // 3. Response Status Capture Handshake
            m_bready = 1;
            while (!m_bvalid) @(posedge aclk);
            @(posedge aclk);
            m_bready = 0;
            $display("[TIME: %0t ns] [MASTER %0d]   STAGE OK: Write Response Complete (BVALID)", $time, master_id);
        end
    endtask

endmodule

// ============================================================================
// BLOCK 2: REACTIVE SLAVE RESPONDER MODEL
// ============================================================================
module axicb_slave_responder (
    input  wire        aclk,
    input  wire        aresetn,
    input  wire        srst,
    input  wire        s_awvalid,
    output logic       s_awready,
    input  wire [7:0]  s_awch,
    input  wire        s_wvalid,
    output logic       s_wready,
    input  wire        s_wlast,
    input  wire [7:0]  s_wch,
    output logic       s_bvalid,
    input  wire        s_bready,
    output logic [7:0] s_bch,
    input  wire        s_arvalid,
    output logic       s_arready,
    output logic       s_rvalid,
    input  wire        s_rready,
    output logic       s_rlast,
    output logic [7:0] s_rch
);

    bit [2:0] backpressure_weight = 0;

    initial begin
        s_awready = 0; s_wready  = 0; s_bvalid  = 0; s_bch     = 0;
        s_arready = 0; s_rvalid  = 0; s_rlast   = 0; s_rch     = 0;

        forever begin
            @(posedge aclk);
            if (aresetn && !srst) begin
                s_awready <= ($urandom_range(0, 7) >= backpressure_weight);
                s_wready  <= ($urandom_range(0, 7) >= backpressure_weight);
                s_arready <= ($urandom_range(0, 7) >= backpressure_weight);

                if (s_awvalid && s_awready) begin
                    repeat($urandom_range(1, 3)) @(posedge aclk);
                    s_bvalid <= 1;
                    s_bch    <= 8'h00; 
                end
                if (s_bvalid && s_bready) begin
                    s_bvalid <= 0;
                end

                if (s_arvalid && s_arready) begin
                    automatic int r_burst_len = $urandom_range(1, 8);
                    for (int beat = 0; beat < r_burst_len; beat++) begin
                        repeat($urandom_range(0, 2)) @(posedge aclk);
                        s_rvalid <= 1;
                        s_rlast  <= (beat == r_burst_len - 1);
                        s_rch    <= 8'hA0 + beat;
                        @(posedge aclk);
                        while (!s_rready) @(posedge aclk);
                        s_rvalid <= 0;
                        s_rlast  <= 0;
                    end
                end
            end
            else begin
                s_awready <= 0;
                s_wready  <= 0;
                s_bvalid  <= 0;
            end
        end
    end

endmodule

// ============================================================================
// BLOCK 3: TOP-LEVEL TEST HARNESS & TEST SUITE RUNNER
// ============================================================================
module axicb_tb_top;

    localparam AXI_ADDR_W        = 8;
    localparam AXI_ID_W          = 8;
    localparam AXI_DATA_W        = 8;
    localparam AXI_SIGNALING     = 1; 
    localparam MST_NB            = 4;
    localparam SLV_NB            = 4;
    localparam MST_PIPELINE      = 1; 
    localparam SLV_PIPELINE      = 1;
    localparam TIMEOUT_ENABLE    = 1;
    localparam NUM_PRIORITY_LVL  = 4;
    localparam PRIORITY_W        = 2;
    localparam OR_NUM_W          = 8;

    localparam AWCH_W = 8; 
    localparam WCH_W  = 8; 
    localparam BCH_W  = 8; 
    localparam ARCH_W = 8; 
    localparam RCH_W  = 8; 

    localparam [AXI_ADDR_W*SLV_NB-1:0] SLV_START_ADDR = {8'hC0, 8'h80, 8'h40, 8'h00};
    localparam [AXI_ADDR_W*SLV_NB-1:0] SLV_END_ADDR   = {8'hFF, 8'hBF, 8'h7F, 8'h3F};

    localparam [PRIORITY_W*MST_NB-1:0] MST_PRIORITY = 8'h2F;
    localparam [MST_NB*SLV_NB-1:0]     MST_ROUTES   = 16'hFFFF; 
    localparam [AXI_ID_W*MST_NB-1:0]   MST_ID_MASK  = 'h30_20_10_00;
    localparam [MST_NB*OR_NUM_W-1:0]   MST_OSTDREQ_NUM = 'h04_04_04_04;

    logic aclk;
    logic aresetn;
    logic srst;

    logic [MST_NB-1:0]       i_awvalid;  logic [MST_NB-1:0]       i_awready;
    logic [MST_NB*AWCH_W-1:0] i_awch;     logic [MST_NB-1:0]       i_wvalid;
    logic [MST_NB-1:0]       i_wready;   logic [MST_NB-1:0]       i_wlast;
    logic [MST_NB*WCH_W-1:0]  i_wch;      logic [MST_NB-1:0]       i_bvalid;
    logic [MST_NB-1:0]       i_bready;   logic [MST_NB*BCH_W-1:0]  i_bch;
    logic [MST_NB-1:0]       i_arvalid;  logic [MST_NB-1:0]       i_arready;
    logic [MST_NB*ARCH_W-1:0] i_arch;     logic [MST_NB-1:0]       i_rvalid;
    logic [MST_NB-1:0]       i_rready;   logic [MST_NB-1:0]       i_rlast;
    logic [MST_NB*RCH_W-1:0]  i_rch;

    logic [SLV_NB-1:0]       o_awvalid;  logic [SLV_NB-1:0]       o_awready;
    logic [SLV_NB*AWCH_W-1:0] o_awch;     logic [SLV_NB-1:0]       o_wvalid;
    logic [SLV_NB-1:0]       o_wready;   logic [SLV_NB-1:0]       o_wlast;
    logic [SLV_NB*WCH_W-1:0]  o_wch;      logic [SLV_NB-1:0]       o_bvalid;
    logic [SLV_NB-1:0]       o_bready;   logic [SLV_NB*BCH_W-1:0]  o_bch;
    logic [SLV_NB-1:0]       o_arvalid;  logic [SLV_NB-1:0]       o_arready;
    logic [SLV_NB*ARCH_W-1:0] o_arch;     logic [SLV_NB-1:0]       o_rvalid;
    logic [SLV_NB-1:0]       o_rready;   logic [SLV_NB-1:0]       o_rlast;
    logic [SLV_NB*RCH_W-1:0]  o_rch;

    // DUT Instantiation
    axicb_switch_top #(
        .AXI_ADDR_W(AXI_ADDR_W), .AXI_ID_W(AXI_ID_W), .AXI_DATA_W(AXI_DATA_W),
        .AXI_SIGNALING(AXI_SIGNALING), .MST_NB(MST_NB), .SLV_NB(SLV_NB),
        .MST_PIPELINE(MST_PIPELINE), .SLV_PIPELINE(SLV_PIPELINE),
        .TIMEOUT_ENABLE(TIMEOUT_ENABLE), .NUM_PRIORITY_LVL(NUM_PRIORITY_LVL),
        .MST_ROUTES(MST_ROUTES), .MST_ID_MASK(MST_ID_MASK), .PRIORITY_W(PRIORITY_W),
        .MST_PRIORITY(MST_PRIORITY), .OR_NUM_W(OR_NUM_W), .MST_OSTDREQ_NUM(MST_OSTDREQ_NUM),
        .SLV_START_ADDR(SLV_START_ADDR), .SLV_END_ADDR(SLV_END_ADDR),
        .AWCH_W(AWCH_W), .WCH_W(WCH_W), .BCH_W(BCH_W), .ARCH_W(ARCH_W), .RCH_W(RCH_W)
    ) dut (.*);

    // Clock System
    initial begin
        aclk = 0;
        forever #5 aclk = ~aclk;
    end

    genvar m;
    genvar s;

    generate
        for (m = 0; m < MST_NB; m++) begin : MST_AGENT_GEN
            axicb_master_driver mst_drv (
                .aclk(aclk), .aresetn(aresetn), .srst(srst),
                .m_awvalid(i_awvalid[m]), .m_awready(i_awready[m]), .m_awch(i_awch[m*AWCH_W +: AWCH_W]),
                .m_wvalid(i_wvalid[m]),   .m_wready(i_wready[m]),   .m_wlast(i_wlast[m]), .m_wch(i_wch[m*WCH_W +: WCH_W]),
                .m_bvalid(i_bvalid[m]),   .m_bready(i_bready[m])
            );
        end

        for (s = 0; s < SLV_NB; s++) begin : SLV_AGENT_GEN
            axicb_slave_responder slv_resp (
                .aclk(aclk), .aresetn(aresetn), .srst(srst),
                .s_awvalid(o_awvalid[s]), .s_awready(o_awready[s]), .s_awch(o_awch[s*AWCH_W +: AWCH_W]),
                .s_wvalid(o_wvalid[s]),   .s_wready(o_wready[s]),   .s_wlast(o_wlast[s]), .s_wch(o_wch[s*WCH_W +: WCH_W]),
                .s_bvalid(o_bvalid[s]),   .s_bready(o_bready[s]),   .s_bch(o_bch[s*BCH_W +: BCH_W]),
                .s_arvalid(o_arvalid[s]), .s_arready(o_arready[s]), .s_rvalid(o_rvalid[s]), .s_rready(o_rready[s]),
                .s_rlast(o_rlast[s]),     .s_rch(o_rch[s*RCH_W +: RCH_W])
            );
        end
    endgenerate

    // Verification Test Sequencing
    initial begin
        // 1. Force explicit initial states at time 0
        aresetn   = 0; 
        srst      = 0;
        i_arvalid = 0; 
        i_arch    = 0; 
        i_rready  = 0;
        
        $display("[START] Unified Modular Verification Environment Online.");
        
        // 2. Synchronous Clock-Driven Reset Sequence (Removes Vivado Race Conditions)
        repeat (4) @(posedge aclk);
        #1 aresetn = 1; // Asserted safely 1ns after clock edge
        repeat (2) @(posedge aclk);
        #1 srst = 1;
        repeat (2) @(posedge aclk);
        #1 srst = 0;
        repeat (4) @(posedge aclk); // Allow internal structures to settle

        // SCENARIO 1: High-Priority Starvation Attack
        $display("\nExecuting Scenario 1: Starvation Flood...");
        fork
            repeat (8) MST_AGENT_GEN[0].mst_drv.drive_write_burst(8'h10, 1, 4'h0);
            repeat (8) MST_AGENT_GEN[1].mst_drv.drive_write_burst(8'h20, 1, 4'h1);
            begin
                repeat (2) @(posedge aclk);
                fork
                    MST_AGENT_GEN[2].mst_drv.drive_write_burst(8'h15, 1, 4'h2);
                    MST_AGENT_GEN[3].mst_drv.drive_write_burst(8'h1A, 1, 4'h3);
                join
            end
        join
        $display("Scenario 1 Cleared.");
        repeat (10) @(posedge aclk);

        // SCENARIO 2: Cross-Traffic Matrix Routing Swap
        $display("\nExecuting Scenario 2: Full Crossbar Matrix Congestion...");
        fork
            MST_AGENT_GEN[0].mst_drv.drive_write_burst(8'hD0, 4, 4'h0);
            MST_AGENT_GEN[1].mst_drv.drive_write_burst(8'h90, 4, 4'h1);
            MST_AGENT_GEN[2].mst_drv.drive_write_burst(8'h50, 4, 4'h2);
            MST_AGENT_GEN[3].mst_drv.drive_write_burst(8'h10, 4, 4'h3);
        join
        repeat (5) @(posedge aclk);
        fork
            MST_AGENT_GEN[0].mst_drv.drive_write_burst(8'h10, 2, 4'h0);
            MST_AGENT_GEN[1].mst_drv.drive_write_burst(8'h50, 2, 4'h1);
            MST_AGENT_GEN[2].mst_drv.drive_write_burst(8'h90, 2, 4'h2);
            MST_AGENT_GEN[3].mst_drv.drive_write_burst(8'hD0, 2, 4'h3);
        join
        $display("Scenario 2 Cleared.");
        repeat (10) @(posedge aclk);

        // SCENARIO 3: Extreme Multi-cycle Slave Backpressure Stalls
        $display("\nExecuting Scenario 3: Asymmetric Pipelines under High Latency...");
        SLV_AGENT_GEN[0].slv_resp.backpressure_weight = 5;
        SLV_AGENT_GEN[1].slv_resp.backpressure_weight = 6;
        SLV_AGENT_GEN[2].slv_resp.backpressure_weight = 4;
        SLV_AGENT_GEN[3].slv_resp.backpressure_weight = 5;

        fork
            MST_AGENT_GEN[0].mst_drv.drive_write_burst(8'h20, 16, 4'h0);
            MST_AGENT_GEN[1].mst_drv.drive_write_burst(8'h60, 8,  4'h1);
            MST_AGENT_GEN[2].mst_drv.drive_write_burst(8'hA0, 4,  4'h2);
            MST_AGENT_GEN[3].mst_drv.drive_write_burst(8'hE0, 1,  4'h3);
        join
        $display("Scenario 3 Cleared.");

        repeat (20) @(posedge aclk);
        $display("\n==================================================================");
        $display("[STATUS] All modular blocks executed successfully without structural deadlocks.");
        $display("==================================================================");
        $finish;
    end

endmodule
