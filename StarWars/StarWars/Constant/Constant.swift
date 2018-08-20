enum Url: String {
  case base = "https://swapi.co/api/"
  case searchPeople = "people/?search="
}

func searchUrl(for name: String) -> String {
  let url = Url.base.rawValue + Url.searchPeople.rawValue + name.trimmingCharacters(in: .whitespaces)
  print(url)
  return url
}
