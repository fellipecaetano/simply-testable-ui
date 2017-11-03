import RxSwift
import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

/**
 * Observables são a abstração básica para sequências de eventos assícronos.
 *
 * Podem ser transformados, filtrados e acumulados como sequências normais
 * da linguagem.
 *
 * São interfaces read-only para uma sequência de eventos e não podem receber
 * novos eventos depois de criados.
 */
let observable: Observable<Int>

/**
 * Observers são uma interface write-only para uma sequência de eventos.
 *
 * Na maior parte dos casos são uma estrutura opaca que recebe eventos mas que
 * os delega para outra estrutura que permite a leitura destes eventos.
 */
let observer: AnyObserver<Int>

/**
 * Subjects são um tipo especial de objeto que age ao mesmo tempo como
 * Observable e Observer. São, portanto, read-write.
 *
 * Existem muitos tipos de Subjects, e cada um entrega eventos de uma forma
 * diference. PublishSubjects são o tipo mais simples e comum e são suficientes
 * para nossas demonstrações.
 */
let subject = PublishSubject<Int>()
observable = subject.asObservable()
observer = subject.asObserver()

observable
    //    .map({ $0 * 3 })
    //    .filter({ $0 % 2 != 0 })
    .subscribe(onNext: { x in print(x) })

observer.onNext(1)
observer.onNext(2)
observer.onNext(3)
