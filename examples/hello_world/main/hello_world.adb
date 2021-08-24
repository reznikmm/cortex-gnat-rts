with System;

procedure Hello_World is

   procedure puts
     (data : System.Address)
      with Import, Convention => C, External_Name => "puts";

   Hello : String := "Hello from Ada!" & ASCII.NUL;
begin
  puts (Hello'Address);
end;
