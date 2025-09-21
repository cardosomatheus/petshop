from faker import Faker

fake = Faker('pt_BR')


def create_many_clients(quantidade: int = 10) -> list:
    """Cria clientes de acordo com o parametro 'quantidade'."""
    if not isinstance(quantidade, int):
        raise ValueError('Quantidade precisa ser um numero inteiro !!!!')

    data = []
    contador = 0
    while contador < quantidade:
        dict_cliente = {}
        
        dict_cliente['nome']     = fake.name()
        dict_cliente['cpf_cnpj'] = fake.cpf()
        dict_cliente['telefone'] = fake.cellphone_number()

        contador += 1
        data.append(dict_cliente)

    return data

