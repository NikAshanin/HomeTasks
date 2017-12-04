import Foundation

final class FilmBuilder {
  static func naiveGenerate() -> ArrayFilms {
    let array = ArrayFilms()
    array.pushFilm(name: "Солярис", description: "Три человека на планете Солярис оказываются в"
        + "предельной, нечеловеческой ситуации. Окруженные своими «гостями», они должны решать,"
        + "что делать. Для доктора Сарториуса главное — долг перед наукой, истиной, которая выше жалости и"
        + "морали. Снаут гнется под тяжестью обрушившихся на него проблем — научных и нравственных.", urlImage: "1")

    array.pushFilm(name: "После́днее та́нго в Пари́же", description: "классический эротический фильм режиссёра Бернардо "
        + "Бертолуччи, вышедший на экраны в 1972 году. Главные роли исполняют Марлон Брандо и Мария "
        + "Шнайдер. Две номинации на премию «Оскар»: за режиссуру Бертолуччи и актёрскую работу Брандо"
        + " (седьмая и последняя в карьере Брандо номинация на «Оскар» за лучшую мужскую роль)."
        + "Картина заняла 48 место в списке 100 лучших американских мелодрам по версии AFI. Фильм "
        + "сочетает в себе элементы эротической и философской мелодрамы.", urlImage: "2")

    array.pushFilm(name: "Легенда о Коловрате", description: "XIII век. Русь раздроблена и вот-вот"
        + "падет на колени перед ханом Золотой Орды Батыем. Испепеляя города и заливая русские земли"
        + "кровью, захватчики не встречают серьезного сопротивления, и лишь один воин бросает им вызов."
        + "Молодой рязанский витязь Евпатий Коловрат возглавляет отряд смельчаков, чтобы отомстить за"
        + "свою любовь и за свою родину. Его отвага поразит даже Батыя, а его имя навсегда останется "
        + "в памяти народа. Воин, ставший легендой. Подвиг, сохранившийся в веках.", urlImage: "3")

    array.pushFilm(name: "Снеговик", description: "В течение многих лет в день"
        + ", когда выпадает первый снег, бесследно исчезают замужние женщины. "
        + "Сложить все части загадочного пазла под силу только знаменитому "
        + "детективу. Он потерял покой и сон, ведь время следующего снегопада неумолимо приближается.",
                   urlImage: "4")

    return array
  }
}
