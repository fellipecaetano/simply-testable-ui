theme: Titillium

# Usando RxSwift para construir UIs simplesmente testáveis

Um live-coding experimental que vai construir um view controller usando RxSwift, view models e um padrão arquitetural baseado em fronteiras em vez de camadas

^ Boa tarde, pessoal. Meu nome é Fellipe Caetano e hoje eu vou mostrar pra vocês na prática como usar RxSwift, algumas técnicas e padrões de design para construir UIs que são muito simples de testar.

---
# Como pegar os múltiplos de 3 que são pares e estão entre 1 e 10?

```swift

let sequence = (1 ... 10)

sequence
  .map({ $0 * 3 }) // Multiplica elementos por 3
  .filter({ $0 % 2 == 0 }) // Remove elementos ímpares
  .forEach({ x in
    assert(x % 2 == 0)
    print(x)
  })
```

^ Primeiro, vamos juntos exercitar um pouco nossos conhecimentos de manipulação de sequências. Nesta talk vamos usar código Swift, naturalmente, mas todos os conceitos que serão expostos se aplicam igualmente bem a qualquer tecnologia.

^ Em Swift, este é provavelmente o jeito mais idiomático de imprimir os múltiplos pares de 3 entre 1 e 10. Primeiro a gente transforma a sequência em uma nova sequência contendo os múltiplos de 3 entre 1 e 10, depois a gente cria uma nova sequência removendo os elementos ímpares. Por fim, a gente imprime os elementos usando um loop.

^ Este estilo de código, emprestado da programação funcional, é bastante comum hoje em dia então imagino que a maior parte de vocês já tenha escrito ou encontrado código assim pelo menos uma vez.

---
# E se os números entre 1 e 10 fossem emitidos de forma assíncrona...

```swift, [.highlight: 1, 6, 9]
let sequence = /* sequência assíncrona de números entre 1 e 10 */

sequence
  .map({ $0 * 3 }) // Multiplica elementos por 3
  .filter({ $0 % 2 == 0 }) // Remove elementos ímpares
  .subscribe(onNext: { x in
    assert(x % 2 == 0)
    print(x)
  })
```

^ Usando este exemplo como base, eu quero colocar duas perguntas que são o alicerce do RxSwift e de bibliotecas análogas que implementam a mesma especificação: (a) existe uma maneira de trabalhar com eventos assícronos como sequências que podem ser manipuladas como arrays? (b) se existe essa maneira, o que se ganha com isso?

---
# ...ao longo do tempo?

```swift, [.highlight: 1-9, 14, 17]
let sequence = Observable<Int>.create { observer in
  for i in (1 ... 10) {
    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
      observer.onNext(i)
    }
  }

  // ...
}

sequence
  .map({ $0 * 3 }) // Multiplica elementos por 3
  .filter({ $0 % 2 == 0 }) // Remove elementos ímpares
  .subscribe(onNext: { x in
    assert(x % 2 == 0)
    print(x)
  })
```

^ A resposta da primeira pergunta é este slide. A segunda pergunta eu vou responder em seguida, mas primeiro eu quero mostrar este exemplo pra vocês.

^ Aqui, a gente está construindo inicialmente a mesma sequência de números de 1 a 10, e queremos chegar no mesmo objetivo: imprimir os múltiplos pares de 3 desta sequência. A gente transforma e filtra a sequência do memso jeito, então no final a gente imprime os mesmos números. A diferença crucial, contudo, é que a sequência dessa vez é assíncrona: os elementos dela são "emitidos" um por vez a cada 500 ms. Esta é a ideia central por traz do funcionamento do RxSwift. 

^ O que eu vou mostrar agora pra vocês são três conceitos essenciais para o entendimento da talk e, por consequência, para o entendimento do RxSwift.

---
[.footer: **\*funções que não causam efeitos colaterais e sempre retornam o mesmo valor para cada conjunto de parâmetros**]

# Isto é RxSwift

RxSwift são abstrações para **eventos assíncronos ao longo tempo**, permitindo que eles sejam **manipulados como sequências** usando operadores funcionais

Estas sequências podem ser **combinadas, transformadas e observadas** usando **funções puras\***

---
# Isto é RxSwift

RxSwift permite usar a **mesma abstração** para taps em botões, input de texto em formulários, respostas de APIs, atualizações de localização geográfica e praticamente **tudo o que é assíncrono e baseado em eventos**

Todas estas tarefas viram **sequências de valores**, que são muito **fáceis de testar**

^ Agora eu vou demonstrar como construir uma UI simplesmente testável usando RxSwift.

^ Pra isso, eu trouxe um esqueleto de um app parcialmente implementado que é apenas uma tela de login.

---

![inline](Assets/demo.mov)

^ A ideia é que no fim da demonstração, nossa UI de login fique assim. São dois campos de texto: e-mail e senha, que são parcialmente validados conforme o usuário digita. O botão de submissão do formulário fica desativado enquanto os campos estejam vazios ou preenchidos com dados inválidos, e um indicador de atividade começa a animar enquanto o login está em progresso. Se as credenciais informadas não batem com o nosso mock de banco de dados no servidor, mensagens de validação aparecem embaixo dos campos. Caso esteja tudo OK, a gente mostra um alerta de sucesso para o usuário.

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
