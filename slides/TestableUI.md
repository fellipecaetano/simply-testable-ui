theme: Titillium

# Usando RxSwift para construir UIs simplesmente testáveis

Um live-coding experimental que vai construir um view controller usando RxSwift, view models e um padrão arquitetural baseado em fronteiras em vez de camadas

---
# Como pegar os múltiplos de 3 que são pares e estão entre 1 e 10?

```swift

let sequence = (1..10)

sequence
  .map({ $0 * 3 }) // Multiplica elementos por 2
  .filter({ $0 % 2 == 0 }) // Remove elementos ímpares
```

---
# E se os números entre 1 e 10 fossem emitidos de forma assíncrona...

```swift, [.highlight: 1, 6-9]
let sequence = /* sequência assíncrona de números entre 1 e 10 */

sequence
  .map({ $0 * 3 }) // Multiplica elementos por 2
  .filter({ $0 % 2 == 0 }) // Remove elementos ímpares
  .subscribe(onNext: { x in
    assert(x % 2 == 0)
    print(x)
  })
```

---
# ...ao longo do tempo?

```swift, [.highlight: 1-9, 14-17]
let sequence = Observable<Int>.create { observer in
  for i in (1 ... 10) {
    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
      observer.onNext(i)
    }
  }

  // ...
}

sequence
  .map({ $0 * 3 }) // Multiplica elementos por 2
  .filter({ $0 % 2 == 0 }) // Remove elementos ímpares
  .subscribe(onNext: { x in
    assert(x % 2 == 0)
    print(x)
  })
```

---
[.footer: **\*funções que não causam efeitos colaterais e sempre retornam o mesmo valor para cada conjunto de parâmetros**]

# Isto é RxSwift

RxSwift são abstrações para **eventos assíncronos ao longo tempo**, permitindo que eles sejam **manipulados como sequências** usando operadores funcionais

Estas sequências podem ser **combinadas, transformadas e observadas** usando **funções puras\***

---
# Isto é RxSwift

RxSwift permite usar a **mesma abstração** para taps em botões, input de texto em formulários, respostas de APIs, atualizações de localização geográfica e praticamente **tudo o que é assíncrono e baseado em eventos**

Todas estas tarefas viram **sequências de valores**, que são muito **fáceis de testar**

---

![inline](Assets/demo.mov)

---
# Em resumo

A abstração de eventos como **sequências de valores emitidos e transformados de forma assíncrona ao longo do tempo** permite **usar TDD para escrever todo o comportamento da UI** (validação de input e lógica de apresentação)

A mesma abstração permite **testar a aparência da nossa UI usando testes de snapshots sem usar mocks**, pois permite que o código de UI lide apenas com **valores que entram e valores que saem**, sem depender de objetos de negócio

---
[.autoscale: true]

# Mais informações

- App de exemplo
**[https://github.com/fellipecaetano/simply-testable-ui](https://github.com/fellipecaetano/simply-testable-ui)**

- Backend de teste
**[https://github.com/fellipecaetano/heimdall-api](https://github.com/fellipecaetano/heimdall-api)**

- Repositório oficial do RxSwift
**[https://github.com/ReactiveX/RxSwift](https://github.com/ReactiveX/RxSwift)**

- RxMarbles
**[http://rxmarbles.com](http://rxmarbles.com)**

- Boundaries, talk de Gary Bernhardt
**[https://www.destroyallsoftware.com/talks/boundaries](https://www.destroyallsoftware.com/talks/boundaries)**

---
[.autoscale: true]

# Sobre mim

- Sou desenvolvedor iOS sênior na Sympla e tenho pouco mais de 6 anos de experiência trabalhando com tecnologias Apple;

- Nasci e fui criado e Campinas e antes da Sympla trabalhei na Movile e na Dextra, primariamente como desenvolvedor iOS mas também como desenvolvedor full-stack;

- Sou entusiasta de desenvolvimento JavaScript e uso a evolução do ecossistema como ponto de partida para minhas pesquisas;

- Minha especialidade é buscar soluções altamente testáveis e simples de evoluir para problemas de várias faixas de complexidade;

- Você consegue me encontrar no [Twitter](https://twitter.com/fellipecaetano_), [GitHub](https://github.com/fellipecaetano), [LinkedIn](https://www.linkedin.com/in/fellipecaetano) e no [Slack](https://iosdevbr.slack.com/messages/@U310SH6JD) da comunidade brasileira do CocoaHeads :v:

---
<br>
<br>
# [fit] Obrigado! :clap:
