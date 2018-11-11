page 50151 "Address Search Setup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Address Search Setup";
    Caption = 'Address Search Setup';

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(LicKey; "License Key")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Get() then begin
            Init();
            Insert();
        end;
    end;
}