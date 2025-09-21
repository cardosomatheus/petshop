from extract.extract_clientes import create_many_clients
from tranform.tranform_cliente import add_email_to_client



if __name__ == "__main__":
    all_cliente = create_many_clients(10)
    add_email_to_client(all_cliente)