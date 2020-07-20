class generic_scb extends uvm_scoreboard

`uvm_component_utils(generic_scb)

uvm_analysis_export(generic_seq_item) m_analysis_export_monitor;
uvm_analysis_export(generic_seq_item) m_analysis_export_driver;

uvm_tlm_analysis_fifo(generic_seq_item) m_uvm_tlm_analysis_fifo_monitor;
uvm_tlm_analysis_fifo(generic_seq_item) m_uvm_tlm_analysis_fifo_driver;

virtual dut_if m_dut_if_h;

generic_seq_item m_seq_item_monitor;

generic_seq_item m_seq_item_driver;

function new(string name, uvm_component parent)
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase)
super.build_phase(phase);
m_analysis_export_monitor = new("m_analysis_export_monitor",this);
m_analysis_export_driver = new("m_analysis_export_driver",this);

m_uvm_tlm_analysis_fifo_monitor = new("m_uvm_tlm_analysis_fifo_monitor",this);
m_uvm_tlm_analysis_fifo_driver = new("m_uvm_tlm_analysis_fifo_monitor",this);

endfunction

function void connect_phase(uvm_phase phase)
super.build_phase(phase);
m_analysis_export_monitor.connect(m_uvm_tlm_analysis_fifo_monitor.analysis_export);
m_analysis_export_monitor.connect(m_uvm_tlm_analysis_fifo_monitor.analysis_export);
endfunction

function void run_phase()
  forever
  begin: begin_scb_forever
    fork
      begin
        m_uvm_tlm_analysis_fifo_monitor.get(m_seq_item_monitor);
      end
      begin
        m_uvm_tlm_analysis_fifo_driver.get(m_seq_item_driver);
      end
      compare(m_seq_item_monitor, m_seq_item_driver);
    join
  end
endfunction

function void report_phase(uvm_phase phase)
  super.report_phase(phase);
  
  if(!fail_cnt) begin
    `uvm_info(get_type_name(),$psprintf("All transactions passed"),UVM_LOW);
  end else
  `uvm_error(get_type_name(),$psprintf("Mismatch in fail_cnt : %0d",fail_cnt));
endfunction

endclass
  
    

   




