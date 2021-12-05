with Ada.Text_IO;
with Ada.Containers.Indefinite_Vectors;
with Ada.Containers.Vectors;
with Ada.Strings;
with Ada.Strings.Unbounded;
with Ada.Strings.Fixed;
with Ada.Strings.Maps;

procedure Dive is
    type Position is record
        X : Integer;
        Y : Integer;
    end record;

    type Dir is (Forward, Up, Down);

    type Direction is record
        D : Dir;
        N : Integer;
    end record;

    package Direction_Vectors is new Ada.Containers.Vectors(Natural, Direction);
    package String_Vectors is new Ada.Containers.Indefinite_Vectors(Natural, String);

    function Tokenize(S : String) return String_Vectors.Vector is
        Start  : Natural := S'First;
        Finish : Natural := 0;
        Output : String_Vectors.Vector;
    begin
        while Start <= S'Last loop
            Ada.Strings.Fixed.Find_Token(S, Ada.Strings.Maps.To_Set(' '), Start, Ada.Strings.Outside, Start, Finish);
            exit when Start > Finish;
            Output.Append(S(Start .. Finish));
            Start := Finish + 1;
        end loop;

        return Output;
    end Tokenize;

    function Calculate_Position(Directions : Direction_Vectors.Vector)
    return Position is
        Pos : Position := (0, 0);
    begin
        for C in Directions.Iterate loop
            case Directions(C).D is
                when Forward => Pos.X := Pos.X + Directions(C).N;
                when Up      => Pos.Y := Pos.Y - Directions(C).N;
                when Down    => Pos.Y := Pos.Y + Directions(C).N;
            end case;
        end loop;

        return Pos;
    end Calculate_Position;

    function Position_With_Aim(Directions : Direction_Vectors.Vector)
    return Position is
        Pos : Position := (0, 0);
        Aim : Integer  := 0;
    begin
        for C in Directions.Iterate loop
            case Directions(C).D is
                when Forward =>
                    Pos.X := Pos.X + Directions(C).N;
                    Pos.Y := Pos.Y + (Aim * Directions(C).N);
                when Up => Aim := Aim - Directions(C).N;
                when Down => Aim := Aim + Directions(C).N;
            end case;
        end loop;

        return Pos;
    end;

    Directions : Direction_Vectors.Vector;
    Line       : String_Vectors.Vector;
    D          : Dir;
    P1         : Position;
    P2         : Position;
begin
    while not Ada.Text_IO.End_Of_File loop
        Line := Tokenize(Ada.Text_IO.Get_Line);
        if Line(0) = "forward" then
            D := Forward;
        elsif Line(0) = "up" then
            D := Up;
        elsif Line(0) = "down" then
            D := Down;
        end if;
        Directions.Append((D, Integer'Value(Line(1))));
    end loop;

    P1 := Calculate_Position(Directions);
    Ada.Text_IO.Put_Line(Integer'Image(P1.X * P1.Y));
    P2 := Position_With_Aim(Directions);
    Ada.Text_IO.Put_Line(Integer'Image(P2.X * P2.Y));
end Dive;
