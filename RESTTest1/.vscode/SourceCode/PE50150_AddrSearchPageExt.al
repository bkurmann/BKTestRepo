pageextension 50150 "Address Search Page Extension" extends "Contact List"
{
    actions
    {
        addfirst(Processing)
        {
            action(AddrSearch)
            {
                Caption = 'Search Address';
                Image = Find;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    AddrService: Codeunit AddressService;
                begin
                    AddrService.ExecuteSearch();
                end;
            }
        }
    }

    var
        myInt: Integer;
}