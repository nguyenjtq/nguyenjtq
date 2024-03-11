import requests

'''
Chris Phan's test script
'''

def computer_command_devicelock(self, passcode, computerId):
    jamfUrl = f'{self._tenant}/JSSResource/computercommands/command/DeviceLock/passcode/{passcode}/id/{computerId}'
    headers = {
        'accept': 'application/xml',
        'Authorization': f'Bearer {self._bearerToken}'
    }
    response = requests.post(jamfUrl, headers=headers)
    if response.status_code == 201:
        print(f'[{response.status_code}] - Successfully locked computer_id: {computerId}, passcode: {passcode}')
    else:
        print(f'[{response.status_code}] Something went wrong...')

def main():
    jamfTenant = 'https://discord.jamfcloud.com'
    jamfId = 'jamf-device-incident-response@discordapp.com'
    jamfSecret = ''
    jamf = JamfClient(jamfTenant, jamfId, jamfSecret)

    with open('devices-to-lock.csv') as file:
        computersToLock = file.readlines()

    # computersToLock = ['YDR9W92F7Q,375,123456']

    for computer in computersToLock:
        computerInfo = computer.strip()
        computerInfo = computerInfo.split(',')
        computerSerial = computerInfo[0]
        jamfComputerId = computerInfo[1]
        jamfLockCode = computerInfo[2]

        print(f'Jamf tasks starting for device_serial: {computerSerial}, device_id: {jamfComputerId}, passcode: {jamfLockCode}')
        # computer = jamf.computer_find_by_id(jamfComputerId)
        # print(computer)
        jamf.computer_command_devicelock(jamfLockCode, jamfComputerId)
    
    jamf.invalidate_bearer_token()
    
    