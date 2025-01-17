# Читаемость, понятность и поддерживаемость кода

Вернёмся к нашей функции:

```python
def validate_user(user):
    """Проверяет юзера, райзит исключение, если с ним что-то не так"""
    validate_user_on_server(user)
    check_username(user)
    check_birthday(user)
```

Представим, что ты пока не очень опытный программист, который только пришел в компанию, и тебе дали задачу добавить ещё одну проверку по юзеру, чтобы валидацию проходили только пользователи, созданные вчера или раньше. Ты этот код очевидно не писал, видишь его впервые и как тут всё работает ещё не знаешь.

Тут `user` — это что? Это [словарь key-value](https://docs.python.org/3/tutorial/datastructures.html#dictionaries)? Это [ORM](https://ru.wikipedia.org/wiki/ORM) объект? Это [Pydantic](https://pydantic-docs.helpmanual.io/) модель? У этого юзера тут есть поле `created_at`, дата создания, или нет? Оно нам в нашей задаче ведь нужно будет.

Как ответить на эти вопросы? Перелопачивать код, который вызывает эту нашу функцию `validate_user`. А там тоже непонятно, что в `user` лежит. Там 100500 функций выше, и где и когда там появляется `user` и что в нём лежит — большой-большой вопрос; плюс мы нашли 2 сценария, в одном наша функция вызывается с `dict`'ом, то есть `user` это словарь, а в другом сценарии функция вызывается с ORM моделью, и возможно еще какой-то код вызывает еще как-то иначе нашу горе-функцию `validate_user`. Вот как с этим жить? Вам может понадобиться конкретно перелопатить весь проект, чтобы понять, как добавить абсолютно простейшую проверку.

А если бы здесь был такой код — то все вопросы решились бы мгновенно:

```python
from dataclasses import dataclass
import datetime

@dataclass
class User:
    username: int
    created_at: datetime.datetime
    birthday: datetime.datetime | None

def validate_user(user: User):
    """Проверяет юзера, райзит исключение, если с ним что-то не так"""
    validate_user_on_server(user)
    check_username(user)
    check_birthday(user)
```

Тут понятно, чем является структура `user`. Тут очевидно, что это класс и у него есть такие-то атрибуты, дата создания юзера, юзернейм и дата рождения юзера. Причем даты хранятся тут не как строки, а как datetime, то есть все вопросы у нас мгновенно снимаются.

Чтение кода значительно облегчилось. Нам понятно, что за данные в `user`, у нас больше нет вопросов, как их обработать. Если вы хотите, чтобы вашим кодом было приятно пользоваться — подсказки типов это обязательный инструмент для вас. Что код принимает на вход? Что он отдаёт на выход? На эти вопросы отвечают подсказки типов.

> Подсказки типов значительно улучшают читаемость кода и облегчают его сопровождение и поддержку.
