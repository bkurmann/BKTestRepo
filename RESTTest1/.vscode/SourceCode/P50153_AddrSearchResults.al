page 50153 "Address Search Results"
{
    PageType = List;
    SourceTable = "Address Search Buffer";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Name; Name)
                {
                    ApplicationArea = All;
                }
                field(Prename; Firstname)
                {
                    ApplicationArea = All;
                }

                field(Maidenname; Maidenname)
                {
                    ApplicationArea = All;
                }

                field(Street; Street)
                {
                    ApplicationArea = All;
                }

                field("Street No."; "Street No.")
                {
                    ApplicationArea = All;
                }

                field(Zip; Zip)
                {
                    ApplicationArea = All;
                }

                field(City; City)
                {
                    ApplicationArea = All;
                }

                field(Phone; Phone)
                {
                    ApplicationArea = All;
                }

                field(Occupation; Occupation)
                {
                    ApplicationArea = All;
                }

                field(Type; Type)
                {
                    ApplicationArea = All;
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(CreateContact)
            {
                ApplicationArea = All;
                Caption = 'Create Contact';
                Image = NewCustomer;
                PromotedIsBig = true;
                Promoted = true;

                trigger OnAction();
                var
                    AddrService: Codeunit AddressService;
                begin
                    AddrService.CreateContact(Rec, false);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if FindFirst() then;
    end;
}