document.addEventListener('DOMContentLoaded', () => {
    const tabButtons = document.querySelectorAll('.tab-button');
    tabButtons.forEach(button => {
        button.addEventListener('click', () => {
            tabButtons.forEach(btn => btn.classList.remove('active'));
            button.classList.add('active');
        });
    });
});
$(document).ready(function() {
    var multipleCancelButton = new Choices('#choices-multiple-remove-button', {
        removeItemButton: true,
        maxItemCount: 5,
        searchResultLimit: 5,
        renderChoiceLimit: 5
    });

    $('#choices-multiple-remove-button').on('change', function(event) {
        var selected = multipleCancelButton.getValue(true);
        if (selected.includes('Wszystkie Wydziały')) {
            multipleCancelButton.clearStore();  // Clear all options
            multipleCancelButton.setChoices([
                { value: 'Wszystkie Wydziały', label: 'Wszystkie Wydziały', selected: true }
            ], 'value', 'label', true);
        }
    });
});