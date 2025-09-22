from auxiliar import remove_accentuation,remove_special_caracter


def add_email_to_client(list_client: list=[]) -> None:
    "Cria um email para cliente baseado no nome do cliente "
    for cliente in list_client:
        nome_sem_acento = remove_accentuation(cliente.get('nome')).lower().replace(' ','')
        nome_sem_acento = remove_special_caracter(nome_sem_acento)

        if nome_sem_acento is not None:
            email = nome_sem_acento+'@example.com'
            cliente['email'] = email



clientes = [
    {'nome': 'Asafe Caldeira', 'cpf_cnpj': '052.194.387-60', 'telefone': '+55 81 9 4821-6971'}, 
    {'nome': 'Sr. Marcos Vinicius da Cunha', 'cpf_cnpj': '319.085.476-93', 'telefone': '+55 (073) 93332 6783'}
]


add_email_to_client(clientes)
print(clientes)