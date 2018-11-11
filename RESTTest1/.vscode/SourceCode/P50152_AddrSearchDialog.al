page 50152 "Address Search Dialog"
{
    PageType = StandardDialog;
    UsageCategory = None;
    Caption = 'Address Search';

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(SearchName; SearchName)
                {
                    ApplicationArea = All;
                    Caption = 'Names/Rubric/Phone';

                }
                field(SearchLocation; SearchLocation)
                {
                    ApplicationArea = All;
                    Caption = 'City/Zip/Canton';
                }
            }
        }
    }

    var
        SearchName: Text;
        SearchLocation: Text;
        SearchString: Text;
        AddrSearchBuf: Record "Address Search Buffer" temporary;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        AddrService: Codeunit AddressService;
    begin
        if CloseAction = CloseAction::OK then begin
            if SearchName <> '' then
                SearchString := 'was=' + PrepareSearchExpression(SearchName);
            if SearchLocation <> '' then begin
                if SearchString <> '' then
                    SearchString := SearchString + '&';
                SearchString := SearchString + 'wo=' + PrepareSearchExpression(SearchLocation);
            end;
            AddrService.SearchAddress(AddrSearchBuf, SearchString);
        end;
    end;

    procedure GetResultBuffer(var AddrSearchResult: Record "Address Search Buffer" temporary)
    begin
        AddrSearchResult.Copy(AddrSearchBuf, true);
    end;

    local procedure PrepareSearchExpression(SearchExpression: Text) ReturnText: Text
    var
        TmpText: Text;
        ExprPart: List of [Text];
    begin
        SearchExpression := DelChr(SearchExpression, '<>');
        SearchExpression := DelChr(SearchExpression, '=', '&?');
        SearchExpression := ConvertStr(SearchExpression, ',;', '  ');
        if SearchExpression = '' then
            exit('');
        while StrPos(SearchExpression, ' ') <> 0 do begin
            ExprPart.Add(CopyStr(SearchExpression, 1, strpos(SearchExpression, ' ') - 1));
            SearchExpression := CopyStr(SearchExpression, strpos(SearchExpression, ' ') + 1);
            SearchExpression := DelChr(SearchExpression, '<');
        end;
        ExprPart.Add(SearchExpression);

        foreach TmpText in ExprPart do begin
            if ReturnText <> '' then
                ReturnText := ReturnText + '+';
            ReturnText := ReturnText + TmpText;
        end;

    end;
}