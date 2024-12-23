enum TypeFile{
  text,
  image,
  file,
  audio,
}
enum StateStream{
  Wait,
  Empty,
  Error
}
enum PowerCommand{
  start,
  shutdown,
  stop,
}
enum StateProblem{
  pending,
  solved,
  unSolved
}
enum StateWorker{
  Accepted,
  Rejected
}
