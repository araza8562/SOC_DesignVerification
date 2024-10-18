//-------------------------------------------------------------------------
//						www.verificationguide.com
//-------------------------------------------------------------------------
`include "environment.sv"
program test(mem_intf intf);
  
  class my_trans extends Transaction;
    
    bit [1:0] count;
    
    function void pre_randomize();
      wr_en.rand_mode(0);
      rd_en.rand_mode(0);
      addr.rand_mode(1);
            
      if(cnt %2 == 0) begin
        wr_en = 1;
        rd_en = 0;
      end 
      else begin
        wr_en = 0;
        rd_en = 1;
        count++;
      end
      cnt++;
    endfunction
    
  endclass
    
  //declaring environment instance
  environment env;
  my_trans my_tr;
  
  initial begin
    //creating environment
    env = new(intf);
    
    my_tr = new();
    
    //setting the repeat count of generator as 4, means to generate 4 packets
    env.gen.repeat_count = 10;
    
    env.gen.tr = my_tr;
    
    //calling run of env, it interns calls generator and driver main tasks.
    env.run();
  end
endprogram