table 50150 "Address Search Buffer"
{
    DataClassification = CustomerContent;
    Caption = 'Address Search Buffer';

    fields
    {
        field(10; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Entry No.';
        }

        field(20; "Type"; Text[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Type';
        }

        field(30; "Name"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Name';
        }

        field(40; "Firstname"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Prename';
        }

        field(50; "Maidenname"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Maidenname';
        }

        field(60; "Street"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Street';
        }

        field(70; "Street No."; Text[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Street No.';
        }

        field(80; "Zip"; Text[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Zip Code';
        }

        field(90; "City"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'City';
        }

        field(100; "Phone"; Text[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Phone';
        }

        field(110; "Occupation"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Profession';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}