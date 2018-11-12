codeunit 50150 AddressService
{
    trigger OnRun()
    begin

    end;

    procedure ExecuteSearch()
    var
        SearchDialog: Page "Address Search Dialog";
        AddrBuffer: Record "Address Search Buffer" temporary;
    begin
        SearchDialog.RunModal();
        SearchDialog.GetResultBuffer(AddrBuffer);
        if AddrBuffer.Count() > 0 then
            Page.RunModal(Page::"Address Search Results", AddrBuffer);
    end;

    procedure SearchAddress(var AddrBuffer: Record "Address Search Buffer" temporary; SearchString: Text)
    var
        AddrSearchSetup: Record "Address Search Setup";
        HttpClient: HttpClient;
        HttpResponse: HttpResponseMessage;
        XMLDoc: XmlDocument;
        RootNode: XmlNode;
        DetailNode: XmlNode;
        AdrNode: XMLNode;
        NodeList: XmlNodeList;
        DetailNodeList: XmlNodeList;
        Element: XmlElement;
        DomMgt: Codeunit "XML Dom Mgt.";
        ResponseContent: Text;
        ElementName: Text;
        EntryCounter: Integer;
        Window: Dialog;

    begin
        if SearchString = '' then
            Error(InvalidSearchExprErr);
        if AddrSearchSetup.Get() then
            if AddrSearchSetup."License Key" <> '' then
                SearchString := SearchString + '&key=' + AddrSearchSetup."License Key";

        Window.Open(DlgTxt);

        if not HttpClient.Get('https://tel.search.ch/api/?' + SearchString, HttpResponse) then
            Error(ConnErr);


        if not HttpResponse.IsSuccessStatusCode then
            Error(WebServErr1 +
                  WebServErr2 +
                  WebServErr3,
                  HttpResponse.HttpStatusCode,
                  HttpResponse.ReasonPhrase);

        HttpResponse.Content.ReadAs(ResponseContent);

        if not XmlDocument.ReadFrom(ResponseContent, XmlDoc) then
            Error(IvalidRespErr);

        if not DomMgt.GetRootNode(XMLDoc, RootNode) then
            Error(RootNodeNotFounderr);

        Element := RootNode.AsXmlElement();
        NodeList := Element.GetChildElements();
        foreach AdrNode in NodeList do begin
            if AdrNode.IsXmlElement() then begin
                ElementName := AdrNode.AsXmlElement.LocalName();
                if AdrNode.AsXmlElement.LocalName() = 'entry' then begin
                    EntryCounter += 1;
                    Element := AdrNode.AsXmlElement();
                    DetailNodeList := Element.GetChildElements();
                    foreach DetailNode in DetailNodeList do begin
                        If DetailNode.IsXmlElement() then begin
                            case DetailNode.AsXmlElement.LocalName() of
                                'type':
                                    AddrBuffer.Type := DetailNode.AsXmlElement.InnerText();
                                'name':
                                    AddrBuffer.Name := Format(DetailNode.AsXmlElement.InnerText(), -MaxStrLen((AddrBuffer.Name)));
                                'firstname':
                                    AddrBuffer.Firstname := Format(DetailNode.AsXmlElement.InnerText(), -MaxStrLen((AddrBuffer.Firstname)));
                                'maidenname':
                                    AddrBuffer.Maidenname := Format(DetailNode.AsXmlElement.InnerText(), -MaxStrLen((AddrBuffer.Maidenname)));
                                'occupation':
                                    AddrBuffer.Occupation := Format(DetailNode.AsXmlElement.InnerText(), -MaxStrLen((AddrBuffer.Occupation)));
                                'street':
                                    AddrBuffer.Street := Format(DetailNode.AsXmlElement.InnerText(), -MaxStrLen((AddrBuffer.Street)));
                                'streetno':
                                    AddrBuffer."Street No." := Format(DetailNode.AsXmlElement.InnerText(), -MaxStrLen((AddrBuffer."Street No.")));
                                'zip':
                                    AddrBuffer.Zip := Format(DetailNode.AsXmlElement.InnerText(), -MaxStrLen((AddrBuffer.Zip)));
                                'city':
                                    AddrBuffer.City := Format(DetailNode.AsXmlElement.InnerText(), -MaxStrLen((AddrBuffer.City)));
                                'phone':
                                    AddrBuffer.Phone := Format(DetailNode.AsXmlElement.InnerText(), -MaxStrLen((AddrBuffer.Phone)));
                            end;
                        end;
                    end;
                    AddrBuffer."Entry No." := EntryCounter;
                    AddrBuffer.Insert();
                end;
            end;
        end;

        Window.Close();
    end;

    procedure CreateContact(var AddrBuffer: Record "Address Search Buffer" temporary; Silent: Boolean)
    var
        Contact: Record Contact;
    begin
        Contact.Init();
        Contact.Insert(True);
        Contact.Type := Contact.Type::Person;
        Contact.Validate("First Name", Format(AddrBuffer.Firstname, -MaxStrLen(Contact."First Name")));
        Contact.Validate(Surname, Format(AddrBuffer.Name, -MaxStrLen(Contact.Surname)));
        Contact.Address := Format(AddrBuffer.Street + ' ' + AddrBuffer."Street No.", -MaxStrLen(Contact.Address));
        Contact."Post Code" := AddrBuffer.Zip;
        Contact.Validate(City, Format(AddrBuffer.City, -MaxStrLen(Contact.City)));
        Contact."Phone No." := Format(AddrBuffer.Phone, -MaxStrLen(Contact."Phone No."));
        Contact.Modify(True);
        if not Silent then
            Message(AddrCreatedtxt, Contact."No.");
    end;

    var
        DlgTxt: Label 'Processing Search...';
        ConnErr: Label 'Unable to connect to web service.';
        InvalidSearchExprErr: Label 'Invalid search query.';
        WebServErr1: Label 'The web service returned an error message:\\';
        WebServErr2: Label 'Status code: %1\';
        WebServErr3: Label 'Description: %2';
        IvalidRespErr: Label 'Invalid response, expected an XML Document as response';
        RootNodeNotFounderr: Label 'Root Node not found';
        AddrCreatedtxt: Label 'Contact "%1" successfully created.';

}