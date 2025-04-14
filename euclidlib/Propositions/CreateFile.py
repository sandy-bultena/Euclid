import pathlib
from itertools import batched

template_path = pathlib.Path(__file__).parent / 'PropTemplate.txt'
template_string = template_path.read_text()
indent = ' ' * 8


def main():
    book_num = int(input("Book Num: "))
    prop_num = int(input("Prop Num: "))
    text_boxes = []
    points = []

    while text_box := input("Extra TextBox?: "):
        text_boxes.append(text_box.split(','))

    while point := input("Extra Points?: "):
        points.append(list(batched(point.split(','), 2)))

    text_boxes = (f't{i} = TextBox(mn_coord({x}, {y}))' for i, (x, y) in enumerate(text_boxes, start=2))
    points = (f'{chr(ord("A") + i)} = ' + ','.join(f'mn_coord({x}, {y})' for x, y in line)
              for i, line in enumerate(points))

    text_boxes_text = f'\n{indent}'.join(text_boxes) + '\n'
    points_text = f'\n{indent}'.join(points) + '\n'

    new_file_text = template_string.format(
        book_num=book_num,
        prop_num=prop_num,
        extra_text_boxes=text_boxes_text,
        extra_points=points_text
    )

    outputPath = pathlib.Path(__file__).parent / f'Book{book_num}' / f'Prop{prop_num:02}.py'
    outputPath.write_text(new_file_text)


if __name__ == '__main__':
    main()