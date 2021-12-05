with Ada.Containers.Vectors;
with Ada.Text_IO;
with Ada.Integer_Text_IO;

procedure Sonar is
    package Int_Vectors is new Ada.Containers.Vectors(Natural, Integer);

    function Count_Increases(Ns : Int_Vectors.Vector) return Integer is
        Num : Integer := 0;
    begin
        for I in Ns.First_Index .. Ns.Last_Index - 1 loop
            if Ns(I + 1) > Ns(I) then
                Num := Num + 1;
            end if;
        end loop;

        return Num;
    end Count_Increases;

    function Count_Windows(Ns : Int_Vectors.Vector) return Integer is
        Num : Integer := 0;
    begin
        for I in Ns.First_Index .. Ns.Last_Index - 3 loop
            if Ns(I+1) + Ns(I+2) + Ns(I+3) > Ns(I) + Ns(I+1) + Ns(I+2) then
                Num := Num + 1;
            end if;
        end loop;

        return Num;
    end Count_Windows;

    procedure Put_Int(N : Integer) is
    begin
        Ada.Integer_Text_IO.Put(N, Width => 0);
        Ada.Text_IO.New_Line;
    end Put_Int;

    Stdin : Ada.Text_IO.File_Type renames Ada.Text_IO.Standard_Input;
    Ns    : Int_Vectors.Vector;
begin
    while not Ada.Text_IO.End_Of_File(Stdin) loop
        Ns.Append(Integer'Value(Ada.Text_IO.Get_Line(Stdin)));
    end loop;

    Put_Int(Count_Increases(Ns));
    Put_Int(Count_Windows(Ns));
end Sonar;
