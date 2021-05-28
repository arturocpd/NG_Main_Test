import { LightningElement } from 'lwc';
export default class HelloWorld extends LightningElement {
  greeting = 'WorldMOD';
  changeHandler(event) {
    this.greeting = event.target.value;
  }
}
