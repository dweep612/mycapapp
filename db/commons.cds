namespace mycapapp.commons;

using {Currency} from '@sap/cds/common';


type Gender       : String(1) enum {
    male = 'M';
    frmale = 'F';
    undisclosed = 'U';
};

// @ - annotation
type AmountT      : Decimal(10, 2) @(
    Semantics.amount.currencyCode: 'CURRENCY_code',
    sap.unit                     : 'CURRENCT_code'
);

type Guid         : String(32);
// type phoneNumber  : String(10) @assert.format: '^(\+91[-\s]?)?[6789]\d{9}$';
type phoneNumber  : String(20) @assert.format: '^(?:\+1\s?)?\(?\d{3}\)?[-.\s]?\d{3}[-.\s]?\d{4}$';
type EmailAddress : String(255) @Communication.IsEmailAddress: true;

// aspect -  structure like a append structure in ABAP
aspect Amount {
    CURRENCY     : Currency @title: '{i18n>XLBL_CURR}';
    GROSS_AMOUNT : AmountT @title: '{i18n>XLBL_GROSSAMT}';
    NET_AMOUNT   : AmountT @title: '{i18n>XLBL_NETAMT}';
    TAX_AMOUNT   : AmountT @title: '{i18n>XLBL_TAXAMT}';
};
