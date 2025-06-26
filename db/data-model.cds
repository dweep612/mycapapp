// refer a resuable module
using {
    cuid,
    Currency
} from '@sap/cds/common';
using {mycapapp.commons} from './commons';


// namespace represent unique ID of our project
namespace mycapapp.db;

// context represent usage of entities - grouping
// Master Data
context master {
    entity businesspartner {
        key NODE_KEY      : commons.Guid @title: '{i18n>XLBL_BPKEY}';
            BP_ROLE       : String(2);
            EMAIL_ADDRESS : String(105);
            PHONE_NUMBER  : String(32);
            FAX_NUMBER    : String(32);
            WEB_ADDRESS   : String(44);
            // Foreign Key relationship
            ADDRESS_GUID  : Association to one address @title: '{i18n>XLBL_ADDRKEY}';
            BP_ID         : String(32) @title: '{i18n>XLBL_BPID}';
            COMPANY_NAME  : String(250) @title: '{i18n>XLBL_COMPANY}';
    }

    entity address {
        key NODE_KEY        : commons.Guid @title: '{i18n>XLBL_ADDRKEY}';
            CITY            : String(44);
            POSTAL_CODE     : String(8);
            STREET          : String(44);
            BUILDING        : String(128);
            COUNTRY         : String(44) @title: '{i18n>XLBL_COUNTRY}';
            ADDRESS_TYPE    : String(44);
            VAL_START_DATE  : Date;
            VAL_END_DATE    : Date;
            LATITUDE        : Decimal;
            LONGITUDE       : Decimal;
            // Backend Relation - help us to read the data of BP from address
            businesspartner : Association to one businesspartner
                                  on businesspartner.ADDRESS_GUID = $self;
    }

    entity product {
        key NODE_KEY       : commons.Guid @title: '{i18n>XLBL_PRODKEY}';
            PRODUCT_ID     : String(28) @title: '{i18n>XLBL_PRODID}';
            TYPE_CODE      : String(2);
            CATEGORY       : String(32) @title: '{i18n>XLBL_PRODCAT}';
            SUPPLIER_GUID  : Association to businesspartner @title: '{i18n>XLBL_BPKEY}';
            TAX_TARIF_CODE : Integer;
            MEASURE_UNIT   : String(2);
            WEIGHT_MEASURE : Decimal(5, 2);
            WEIGHT_UNIT    : String(2);
            CURRENCY_CODE  : String(4);
            PRICE          : Decimal(15, 2);
            WIDTH          : Decimal(15, 2);
            DEPTH          : Decimal(15, 2);
            HEIGHT         : Decimal(15, 2);
            DIM_UNIT       : String(2);
            DESCRIPTION    : localized String(255) @title: '{i18n>XLBL_PRODDESC}';
    }

    entity employees : cuid {
        // key ID            : UUID;
        nameFirst     : String(40);
        nameMiddle    : String(40);
        nameLast      : String(40);
        nameInitials  : String(40);
        sex           : commons.Gender;
        language      : String(1);
        phoneNumber   : commons.phoneNumber;
        email         : commons.EmailAddress;
        loginName     : String(32);
        currency      : Currency;
        salaryAmount  : commons.AmountT;
        accountNumber : String(16);
        bankId        : String(40);
        bankName      : String(64);
    }
}

// Transaction Data
context transaction {
    entity purchaseorder : commons.Amount, cuid {
        // key NODE_KEY         : commons.Guid;
        PO_ID            : String(40) @title: '{i18n>XLBL_POID}';
        PARTNER_GUID     : Association to one master.businesspartner @title: '{i18n>XLBL_BPKEY}';
        CURRENCY         : Currency;
        LIFECYCLE_STATUS : String(1) @title: '{i18n>XLBL_LIFESTATUS}';
        OVERALL_STATUS   : String(1) @title: '{i18n>XLBL_OVERALLSTATUS}';
        Items            : Composition of many poitems
                               on Items.PARENT_KEY = $self;
    }

    entity poitems : commons.Amount, cuid {
        // key NODE_KEY     : commons.Guid;
            PARENT_KEY   : Association to one purchaseorder @title: '{i18n>XLBL_POKEY}';
            PO_ITEM_POS  : Integer @title: '{i18n>XLBL_ITEMPOS}';
            PRODUCT_GUID : Association to one master.product @title: '{i18n>XLBL_PRODKEY}';
    }
}
