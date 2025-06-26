using CatalogService as service from '../../srv/CatalogService';

annotate service.POSet with @(

    UI.SelectionFields    : [
        PO_ID,
        PARTNER_GUID.COMPANY_NAME,
        PARTNER_GUID.ADDRESS_GUID.COUNTRY,
        GROSS_AMOUNT,
        CURRENCY_code,
        OVERALL_STATUS
    ],

    UI.LineItem           : [
        {
            $Type: 'UI.DataField',
            Value: PO_ID,
        },
        {
            $Type: 'UI.DataField',
            Value: PARTNER_GUID.COMPANY_NAME,
        },
        {
            $Type: 'UI.DataField',
            Value: PARTNER_GUID.ADDRESS_GUID.COUNTRY
        },
        {
            $Type: 'UI.DataField',
            Value: GROSS_AMOUNT,
        },
        {
            $Type : 'UI.DataFieldForAction',
            Label : 'Boost',
            Inline: true,
            Action: 'CatalogService.boost',
        },
        {
            $Type: 'UI.DataField',
            Value: CURRENCY_code,
        },
        {
            $Type      : 'UI.DataField',
            Criticality: IconColor,
            Value      : OverallStatusText,
        },
    ],

    UI.HeaderInfo         : {
        TypeName      : 'Purchase Order',
        TypeNamePlural: 'Purchase Orders',
        Title         : {Value: PO_ID},
        Description   : {Value: PARTNER_GUID.COMPANY_NAME}
    },

    UI.Facets             : [
        {
            $Type : 'UI.CollectionFacet',
            Label : 'General Information',
            Facets: [
                {
                    $Type : 'UI.ReferenceFacet',
                    Label : 'Order Details',
                    Target: '@UI.Identification',
                },
                {
                    $Type : 'UI.ReferenceFacet',
                    Label : 'Pricing',
                    Target: '@UI.FieldGroup#Pricing',
                },
                {
                    $Type : 'UI.ReferenceFacet',
                    Label : 'Status',
                    Target: '@UI.FieldGroup#Status',
                }
            ],
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Order Items',
            Target: 'Items/@UI.LineItem',
        }
    ],
    UI.Identification     : [
        {
            $Type: 'UI.DataField',
            Value: PO_ID,
        },
        {
            $Type: 'UI.DataField',
            Value: PARTNER_GUID_NODE_KEY,
        },
        {
            $Type: 'UI.DataField',
            Value: LIFECYCLE_STATUS,
        },
        {
            $Type : 'UI.DataFieldForAction',
            Label : 'Deliver',
            Action: 'CatalogService.setDelivered',
        }
    ],
    UI.FieldGroup #Pricing: {
        Label: 'Pricing',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: GROSS_AMOUNT,
            },
            {
                $Type: 'UI.DataField',
                Value: NET_AMOUNT,
            },
            {
                $Type: 'UI.DataField',
                Value: TAX_AMOUNT,
            }
        ],
    },
    UI.FieldGroup #Status : {
        Label: 'Staus Info',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: CURRENCY_code,
            },
            {
                $Type: 'UI.DataField',
                Value: OVERALL_STATUS,
            }
        ],
    },
);

annotate service.POItemSet with @(
    UI.LineItem               : [
        {
            $Type: 'UI.DataField',
            Value: PO_ITEM_POS,
        },
        {
            $Type: 'UI.DataField',
            Value: PRODUCT_GUID_NODE_KEY,
        },
        {
            $Type: 'UI.DataField',
            Value: GROSS_AMOUNT,
        },
        {
            $Type: 'UI.DataField',
            Value: CURRENCY_code,
        },
        {
            $Type: 'UI.DataField',
            Value: TAX_AMOUNT,
        },
        {
            $Type: 'UI.DataField',
            Value: NET_AMOUNT,
        },
    ],
    UI.HeaderInfo             : {
        TypeName      : 'Order Item',
        TypeNamePlural: 'Order Items',
        Title         : {Value: PO_ITEM_POS},
        Description   : {Value: PRODUCT_GUID.ProductName}
    },
    UI.Facets                 : [
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Item Details',
            Target: '@UI.Identification',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Product Information',
            Target: '@UI.FieldGroup#ProductInfo',
        }
    ],
    UI.Identification         : [
        {
            $Type: 'UI.DataField',
            Value: PO_ITEM_POS,
        },
        {
            $Type: 'UI.DataField',
            Value: PRODUCT_GUID_NODE_KEY,
        },
        {
            $Type: 'UI.DataField',
            Value: GROSS_AMOUNT,
        },
        {
            $Type: 'UI.DataField',
            Value: CURRENCY_code,
        },
        {
            $Type: 'UI.DataField',
            Value: TAX_AMOUNT,
        },
        {
            $Type: 'UI.DataField',
            Value: NET_AMOUNT,
        },
    ],
    UI.FieldGroup #ProductInfo: {
        Label: 'Product Info',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: PRODUCT_GUID.ProductId
            },
            {
                $Type: 'UI.DataField',
                Value: PRODUCT_GUID.ProductName
            },
            {
                $Type: 'UI.DataField',
                Value: PRODUCT_GUID.Category
            },
            {
                $Type: 'UI.DataField',
                Value: PRODUCT_GUID.SupplierName
            },
        ],
    },
);

annotate service.POSet with {
    PARTNER_GUID   @(
        Common.Text     : PARTNER_GUID.COMPANY_NAME,
        ValueList.entity: service.BusinessPartnerSet
    );
    OVERALL_STATUS @(Common.Text: OverallStatusText);
};

annotate service.POItemSet with {
    PRODUCT_GUID @(
        Common.Text     : PRODUCT_GUID.ProductName,
        ValueList.entity: service.ProductSet
    )
};

// Define a value help from an entity
@cds.odata.valuelist
annotate service.BusinessPartnerSet with @(UI.Identification: [{
    $Type: 'UI.DataField',
    Value: COMPANY_NAME,
}], );

@cds.odata.valuelist
annotate service.ProductSet with @(UI.Identification: [{
    $Type: 'UI.DataField',
    Value: ProductName,
}], );
