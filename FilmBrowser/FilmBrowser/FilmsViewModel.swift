import Foundation

final class FilmsViewModel: NSObject {
    let films = [Film(name: "Лицо со шрамом", director: "Брайан Де Пальма", resourseId: "scarface"),
                 Film(name: "Крестный отец", director: "Фрэнсис Форд Коппола", resourseId: "godfather"),
                 Film(name: "Хулиганы Зеленой улицы", director: "Лекси Александр", resourseId: "hooligans"),
                 Film(name: "Властелин колец: Две крепости", director: "Питер Джексон", resourseId: "lotr")]
}
