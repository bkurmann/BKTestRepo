table 50151 "Address Search Setup"
{
    DataClassification = CustomerContent;
    Caption = 'Address Search Setup';

    fields
    {
        field(10; "Primary Key"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Primary Key';
        }

        field(20; "License Key"; Text[36])
        {
            DataClassification = CustomerContent;
            Caption = 'License Key';
        }
    }

    keys
    {
        key(PK; "Primary Key")
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