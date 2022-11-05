import { Todo } from "./db";


export function priorityToText(priority: Todo["priority"]): string {
  switch (priority) {
    case 1:
      return "低优先级";
    case 2:
      return "高优先级";
    default:
      return "无优先级";
  }
}