
disable_swap:
  cmd.run:
    {% if grains.get('os') == 'Raspbian' %}
    - name: sudo dphys-swapfile swapoff && sudo dphys-swapfile uninstall && sudo update-rc.d dphys-swapfile remove
    {% else %}
    - name: sudo swapoff -a || (echo "3" > /proc/sys/vm/drop_caches; sleep 10; echo "0" > /proc/sys/vm/drop_caches; sleep 10; sudo swapoff -a) 
    {% endif %}
    - onlyif:
      - sudo swapon --summary|grep -vwE ^Filename
