import unicodedata
import re


def remove_accentuation(text: str) -> str:
    "Normaliza a acentuação do texto"
    palavra_sem_acento = unicodedata.normalize('NFKD', text).encode('ASCII', 'ignore').decode('ASCII')
    palavra_sem_acento = remover_special_caracter(palavra_sem_acento)
    
    return palavra_sem_acento


def remover_special_caracter(texto):
    "Substitui tudo que não for letra número ou espaço por ''"
    return re.sub(r'[^A-Za-z0-9 ]+', '', texto)


#texto  = 'JOç~~/8iiiRãõ!GE. JLL'
#print(remove_accentuation(text=texto))

