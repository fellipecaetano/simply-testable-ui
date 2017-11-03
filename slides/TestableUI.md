# Como pegar os **múltiplos de 3** que são **pares** e estão **entre 1 e 10**?

```swift

let sequence = (1..10)

sequence
  .map({ $0 * 3 }) // Multiplica elementos por 2
  .filter({ $0 % 2 == 0 }) // Remove elementos ímpares
```

---
# E se os números entre 1 e 10 fossem **emitidos de forma assíncrona...**

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
# **...ao longo do tempo**?

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

RxSwift são abstrações para **eventos assíncronos ao longo tempo**, permitindo que eles sejam **manipulados como sequências** usando operadores funcionais

Estas sequências podem ser **combinadas, transformadas e observadas** usando **funções puras\***

---

RxSwift permite que usemos a **mesma abstração** para taps em botões, input de texto em formulários, respostas de APIs, atualizações de localização geográfica e praticamente **tudo o que é assíncrono e baseado em eventos**

Todas estas tarefas viram **sequências de valores**, que são muito **fáceis de testar**

---

![inline](Assets/demo.mov)

---
# Em resumo

A abstração de eventos como **sequências de valores emitidos e transformados de forma assíncrona ao longo do tempo** permite **usar TDD para escrever todo o comportamento da UI** (validação de input e lógica de apresentação)

A mesma abstração permite **testar a aparência da nossa UI usando testes de snapshots sem usar mocks**, pois permite que o código de UI lide apenas com **valores que entram e valores que saem**, sem depender de objetos de negócio
