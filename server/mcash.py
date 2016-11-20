from time import time
import json
import requests
import settings
import logging
import os

logger = logging.getLogger()
logger.setLevel(logging.INFO)
headers = {
        'Authorization': 'SECRET %s' % settings.MCASH_SECRET,
        'X-Mcash-Merchant': settings.MCASH_MERCHANT_ID,
        'X-Mcash-User': settings.MCASH_MERCHANT_USER,
        'X-Testbed-Token': settings.MCASH_TESTBED_TOKEN,
        'Content-Type': 'application/json',
        }


def create_payment(amount='123.00', customer=None,
                   callback_uri='{}/payment/callback'
                   .format(os.getenv('SERVER_BASE')),
                   text='Please pay',
                   required_scope='',
                   required_scope_text='Please share data'):

    data = {'amount': amount,
            'customer': customer,
            'callback_uri': callback_uri,
            'text': text,
            'currency': 'NOK',
            'action': 'auth',
            'pos_id': 'krugerpos',
            'pos_tid': str(time()),
            'allow_credit': True
            }

    res = requests.post(settings.MCASH_BASE_URL +
                        '/merchant/v1/payment_request/',
                        json=data, headers=headers)

    return res


def get_payment(tid):
    res = requests.get(settings.MCASH_BASE_URL +
                       '/merchant/v1/payment_request/%s/'
                       % tid, headers=headers)
    print(str(res))
    return res
