from azure.servicebus import ServiceBusClient, ServiceBusMessage
import os

PRIMARY_CONNECTION_STR = os.getenv("PRIMARY_SERVICE_BUS_CONNECTION")
SECONDARY_CONNECTION_STR = os.getenv("SECONDARY_SERVICE_BUS_CONNECTION")
QUEUE_NAME = "TransactionQueue"

def send_message(connection_str):
    try:
        servicebus_client = ServiceBusClient.from_connection_string(connection_str)
        sender = servicebus_client.get_queue_sender(queue_name=QUEUE_NAME)
        with sender:
            message = ServiceBusMessage("Transaction Processed")
            sender.send_messages(message)
            print("Message sent successfully")
    except Exception as e:
        print(f"Error sending message: {str(e)}")

if __name__ == "__main__":
    try:
        send_message(PRIMARY_CONNECTION_STR)
    except:
        print("Primary namespace failed, trying secondary")
        send_message(SECONDARY_CONNECTION_STR)
