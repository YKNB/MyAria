import { Component, signal } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import {Toolbar, ToolbarWidget, ToolbarWidgetGroup} from '@angular/aria/toolbar';

@Component({
  selector: 'app-root',
  imports: [RouterOutlet, Toolbar, ToolbarWidget, ToolbarWidgetGroup],
  templateUrl: './app.html',
  styleUrl: './app.scss'
})
export class App {
  protected readonly title = signal('MyAria');
}
